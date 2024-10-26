import CoreLocation
import Combine

// Rolling Average measurement structure
struct BeaconMeasurement {
    let accuracy: Double
    let proximity: CLProximity
    let timestamp: Date
    
    var isStale: Bool {
        Date().timeIntervalSince(timestamp) > 5.0 // 5 seconds stale threshold
    }
}

struct RollingBeaconData {
    private(set) var measurements: [BeaconMeasurement] = []
    private let maxMeasurements: Int
    
    init(maxMeasurements: Int = 5) {
        self.maxMeasurements = maxMeasurements
    }
    
    mutating func addMeasurement(_ measurement: BeaconMeasurement) {
        measurements.append(measurement)
        if measurements.count > maxMeasurements {
            measurements.removeFirst()
        }
    }
    
    func getAverageAccuracy() -> Double? {
        let validMeasurements = measurements.filter { !$0.isStale }
        guard !validMeasurements.isEmpty else { return nil }
        
        // Calculate weighted average based on recency
        let total = validMeasurements.enumerated().reduce(0.0) { sum, element in
            let weight = Double(element.offset + 1) // More recent measurements have higher weight
            return sum + (element.element.accuracy * weight)
        }
        
        let weights = (1...validMeasurements.count).reduce(0) { $0 + $1 }
        return total / Double(weights)
    }
    
    func getMostFrequentProximity() -> CLProximity {
        let validMeasurements = measurements.filter { !$0.isStale }
        guard !validMeasurements.isEmpty else { return .unknown }
        
        let proximityCount = validMeasurements.reduce(into: [:]) { counts, measurement in
            counts[measurement.proximity, default: 0] += 1
        }
        
        return proximityCount.max(by: { $0.value < $1.value })?.key ?? .unknown
    }
}

struct BeaconConfig: Identifiable {
    let id = UUID()
    let name: String
    let uuid: UUID
    var segments: [BeaconSegment]
    
    struct BeaconSegment: Identifiable {
        let id = UUID()
        let name: LocationEnum
        let major: UInt16
        let minor: UInt16
    }
}

struct DetectedBeacon: Identifiable {
    let id = UUID()
    let locationName: LocationEnum
    let accuracy: Double
    let proximity: CLProximity
    let lastUpdate: Date
    let uuid: UUID
    
    static var noDetection: DetectedBeacon {
        DetectedBeacon(
            locationName: .none,
            accuracy: 0,
            proximity: .unknown,
            lastUpdate: Date(),
            uuid: UUID()
        )
    }
}

class BeaconDetection: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = BeaconDetection()
    
    // Published properties
    @Published private(set) var detectedBeacon: DetectedBeacon = .noDetection
    @Published private(set) var activeBeacons: [UUID: DetectedBeacon] = [:]
    @Published private var isLocationSegmentChange: Bool = false
    
    // Rolling average storage
    private var rollingData: [UUID: [String: RollingBeaconData]] = [:]
    
    // Configuration
    private let locationManager = CLLocationManager()
    private let staleDataThreshold: TimeInterval = 5.0
    private let minimumAccuracyThreshold = 0.4
    private let maximumAcceptableAccuracy = 10.0
    private let rollingAverageWindow = 5 // Number of measurements to keep
    
    // Cache
    private var beaconConfigsByUUID: [UUID: BeaconConfig] = [:]
    
    // Static beacon configurations
    private static let beaconConfigs = LyfBeaconConfigs
    
    private override init() {
        super.init()
        setupLocationManager()
        setupBeaconConfigCache()
        setupRollingDataStorage()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func setupBeaconConfigCache() {
        Self.beaconConfigs.forEach { config in
            beaconConfigsByUUID[config.uuid] = config
        }
    }
    
    private func setupRollingDataStorage() {
        Self.beaconConfigs.forEach { config in
            var segmentData: [String: RollingBeaconData] = [:]
            config.segments.forEach { segment in
                let key = "\(segment.major)-\(segment.minor)"
                segmentData[key] = RollingBeaconData(maxMeasurements: rollingAverageWindow)
            }
            rollingData[config.uuid] = segmentData
        }
    }
    
    private func getSegmentKey(_ major: UInt16, _ minor: UInt16) -> String {
        return "\(major)-\(minor)"
    }
    
    private func updateRollingData(uuid: UUID, beacon: CLBeacon) {
        let key = getSegmentKey(beacon.major.uint16Value, beacon.minor.uint16Value)
        let measurement = BeaconMeasurement(
            accuracy: beacon.accuracy,
            proximity: beacon.proximity,
            timestamp: Date()
        )
        
        rollingData[uuid]?[key]?.addMeasurement(measurement)
    }
    
    private func getSmoothedAccuracy(uuid: UUID, major: UInt16, minor: UInt16) -> Double? {
        let key = getSegmentKey(major, minor)
        return rollingData[uuid]?[key]?.getAverageAccuracy()
    }
    
    private func getSmoothedProximity(uuid: UUID, major: UInt16, minor: UInt16) -> CLProximity {
        let key = getSegmentKey(major, minor)
        return rollingData[uuid]?[key]?.getMostFrequentProximity() ?? .unknown
    }
    
    func startMonitoring() {
        guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) else {
            print("Beacon monitoring not available")
            return
        }
        
        Self.beaconConfigs.forEach { config in
            let constraint = CLBeaconIdentityConstraint(uuid: config.uuid)
            let region = CLBeaconRegion(
                beaconIdentityConstraint: constraint,
                identifier: config.name
            )
            
            locationManager.startMonitoring(for: region)
            locationManager.startRangingBeacons(satisfying: constraint)
        }
    }
    
    func stopMonitoring() {
        Self.beaconConfigs.forEach { config in
            let constraint = CLBeaconIdentityConstraint(uuid: config.uuid)
            let region = CLBeaconRegion(
                beaconIdentityConstraint: constraint,
                identifier: config.name
            )
            
            locationManager.stopMonitoring(for: region)
            locationManager.stopRangingBeacons(satisfying: constraint)
        }
        
        activeBeacons.removeAll()
        detectedBeacon = .noDetection
        rollingData.removeAll()
        setupRollingDataStorage()
    }
    
    private func updateActiveBeacons(uuid: UUID, beacons: [CLBeacon]) {
        guard let config = beaconConfigsByUUID[uuid] else { return }
        
        // Update rolling averages for all detected beacons
        beacons.forEach { beacon in
            updateRollingData(uuid: uuid, beacon: beacon)
        }
        
        // Find nearest beacon using smoothed data
        if let nearestBeacon = beacons.min(by: { beacon1, beacon2 in
            let smooth1 = getSmoothedAccuracy(uuid: uuid,
                                            major: beacon1.major.uint16Value,
                                            minor: beacon1.minor.uint16Value) ?? Double.infinity
            let smooth2 = getSmoothedAccuracy(uuid: uuid,
                                            major: beacon2.major.uint16Value,
                                            minor: beacon2.minor.uint16Value) ?? Double.infinity
            return smooth1 < smooth2
        }),
           let segment = findSegment(in: config, matching: nearestBeacon),
           let smoothedAccuracy = getSmoothedAccuracy(uuid: uuid,
                                                    major: nearestBeacon.major.uint16Value,
                                                    minor: nearestBeacon.minor.uint16Value) {
            
            let smoothedProximity = getSmoothedProximity(uuid: uuid,
                                                        major: nearestBeacon.major.uint16Value,
                                                        minor: nearestBeacon.minor.uint16Value)
            
            let newDetection = DetectedBeacon(
                locationName: segment.name,
                accuracy: smoothedAccuracy,
                proximity: smoothedProximity,
                lastUpdate: Date(),
                uuid: uuid
            )
            
            // Update active beacons map if accuracy is acceptable
            if smoothedAccuracy <= maximumAcceptableAccuracy {
                activeBeacons[uuid] = newDetection
                
                // Update main detection if this is the nearest beacon overall
                if let nearest = findNearestActiveBeacon() {
                    let isNewLocation = detectedBeacon.locationName != nearest.locationName
                    if isNewLocation {
                        isLocationSegmentChange = true
                        detectedBeacon = nearest
                    }
                }
            }
        }
    }
    
    private func findNearestActiveBeacon() -> DetectedBeacon? {
        return activeBeacons.values.min { $0.accuracy < $1.accuracy }
    }
    
    private func findSegment(in config: BeaconConfig, matching beacon: CLBeacon) -> BeaconConfig.BeaconSegment? {
        return config.segments.first {
            $0.major == beacon.major.uint16Value &&
            $0.minor == beacon.minor.uint16Value
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying constraint: CLBeaconIdentityConstraint) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if beacons.isEmpty {
                self.activeBeacons[constraint.uuid] = nil
                if self.activeBeacons.isEmpty {
                    self.detectedBeacon = .noDetection
                } else if let nearest = self.findNearestActiveBeacon() {
                    self.detectedBeacon = nearest
                }
                return
            }
            
            self.updateActiveBeacons(uuid: constraint.uuid, beacons: beacons)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let beaconRegion = region as? CLBeaconRegion else { return }
            
            self.activeBeacons[beaconRegion.uuid] = nil
            if self.activeBeacons.isEmpty {
                self.detectedBeacon = .noDetection
            } else if let nearest = self.findNearestActiveBeacon() {
                self.detectedBeacon = nearest
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.activeBeacons[beaconConstraint.uuid] = nil
            if self.activeBeacons.isEmpty {
                self.detectedBeacon = .noDetection
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let beaconRegion = region as? CLBeaconRegion else { return }
            
            self.activeBeacons[beaconRegion.uuid] = nil
            if self.activeBeacons.isEmpty {
                self.detectedBeacon = .noDetection
            }
        }
    }
}
