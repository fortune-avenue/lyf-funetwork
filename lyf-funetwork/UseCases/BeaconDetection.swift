//
//  BeaconDetector.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import CoreLocation
import Combine

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
    
    static var noDetection: DetectedBeacon {
        DetectedBeacon(
            locationName: .none,
            accuracy: 0,
            proximity: .unknown,
            lastUpdate: Date()
        )
    }
}

class BeaconDetection: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Singleton instance
    static let shared = BeaconDetection()
    
    // Published properties for SwiftUI updates
    @Published private(set) var detectedBeacon: DetectedBeacon = .noDetection
    @Published private var isLocationSegmentChange : Bool = false
    
    // Private properties
    private let locationManager = CLLocationManager()
    
    // Configuration
    private let staleDataThreshold: TimeInterval = 5.0
    private let minimumAccuracyThreshold = 5.0
    
    private var lastLocationUpdate: Date?
    
    // Static beacon configurations
    private static let beaconConfigs = [
        BeaconConfig(
            name: "gym",
            uuid: UUID(uuidString: "74278BDA-B644-4520-8F0C-720EAF059935")!,
            segments: [
                BeaconConfig.BeaconSegment(name: .gymA, major: 1, minor: 1),
                BeaconConfig.BeaconSegment(name: .gymB, major: 1, minor: 2),
                BeaconConfig.BeaconSegment(name: .gymC, major: 1, minor: 3)
            ]
        ),
        BeaconConfig(
            name: "kitchen",
            uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!,
            segments: [
                BeaconConfig.BeaconSegment(name: .kitchen, major: 1, minor: 1)
            ]
        ),
        BeaconConfig(
            name: "laundry",
            uuid: UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!,
            segments: [
                BeaconConfig.BeaconSegment(name: .laundry, major: 1, minor: 1)
            ]
        ),
        
        BeaconConfig(
            name: "coworking",
            uuid: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
            segments: [
                BeaconConfig.BeaconSegment(name: .coworkingA, major: 1, minor: 1),
                BeaconConfig.BeaconSegment(name: .coworkingB, major: 1, minor: 2),
                BeaconConfig.BeaconSegment(name: .coworkingC, major: 1, minor: 3)
            ]
        )
    ]
    
    // Private initializer for singleton
    private override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startMonitoring() {
        guard CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) else {
            print("Beacon monitoring not available")
            return
        }
        
        for config in Self.beaconConfigs {
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
        for config in Self.beaconConfigs {
            let constraint = CLBeaconIdentityConstraint(uuid: config.uuid)
            let region = CLBeaconRegion(
                beaconIdentityConstraint: constraint,
                identifier: config.name
            )
            
            locationManager.stopMonitoring(for: region)
            locationManager.stopRangingBeacons(satisfying: constraint)
        }
        
        // Reset to no detection state when stopping
        detectedBeacon = .noDetection
    }
    
    private func shouldUpdateLocation(newAccuracy: Double, currentAccuracy: Double?) -> Bool {
        guard let current = currentAccuracy else { return true }
        
        // If new accuracy is significantly better, update
        if newAccuracy < current - minimumAccuracyThreshold {
            return true
        }
        
        // If current location is stale, update
        if Date().timeIntervalSince(detectedBeacon.lastUpdate) > staleDataThreshold {
            return true
        }
        
        return true
    }
    
    private func findBeaconConfig(for uuid: UUID) -> BeaconConfig? {
        Self.beaconConfigs.first { $0.uuid == uuid }
    }
    
    private func findSegment(in config: BeaconConfig, matching beacon: CLBeacon) -> BeaconConfig.BeaconSegment? {
        config.segments.first {
            $0.major == beacon.major.uint16Value &&
            $0.minor == beacon.minor.uint16Value
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying constraint: CLBeaconIdentityConstraint) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            print("-----------------------------------")
            print("beacons detected: \(beacons)")
            print("-----------------------------------")
            // Handle case when no beacons are detected
            if beacons.isEmpty {
                if Date().timeIntervalSince(self.detectedBeacon.lastUpdate) > self.staleDataThreshold {
                    self.detectedBeacon = .noDetection
                }
                return
            }
            
            // Find nearest beacon and update if valid
            if let config = self.findBeaconConfig(for: constraint.uuid),
               let nearestBeacon = beacons.min(by: { $0.accuracy < $1.accuracy }),
               let segment = self.findSegment(in: config, matching: nearestBeacon) {
                
                print("nearest : \(nearestBeacon)")
                if self.shouldUpdateLocation(newAccuracy: nearestBeacon.accuracy, currentAccuracy: self.detectedBeacon.accuracy) {
                    
                    let newDetection = DetectedBeacon(
                        locationName: segment.name,
                        accuracy: nearestBeacon.accuracy,
                        proximity: nearestBeacon.proximity,
                        lastUpdate: Date()
                    )
                    
                    print("Updating location to \(newDetection)")
            
                    self.isLocationSegmentChange = self.detectedBeacon.locationName != newDetection.locationName
                    self.detectedBeacon = newDetection
                }
            }
        }
    }
    
    // Handle when user exits a beacon region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        DispatchQueue.main.async { [weak self] in
            self?.detectedBeacon = .noDetection
        }
    }
    
    // Handle ranging failures
    func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.detectedBeacon = .noDetection
        }
    }
    
    // Handle when monitoring fails
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.detectedBeacon = .noDetection
        }
    }}
