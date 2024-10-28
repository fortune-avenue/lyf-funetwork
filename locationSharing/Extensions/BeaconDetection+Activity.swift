//
//  BeaconDetection+Actovity.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import ActivityKit
import Foundation
import CoreLocation

extension BeaconDetection {
    private func proximityString(_ proximity: CLProximity) -> String {
           switch proximity {
           case .immediate: return "Immediate"
           case .near: return "Near"
           case .far: return "Far"
           case .unknown: return "Unknown"
           @unknown default: return "Unknown"
           }
       }
    
    func startLiveActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities not enabled")
            return
        }
        
        let attributes = LocationAttributes(userName: "User")
        let contentState = LocationAttributes.ContentState(
            locationName: detectedBeacon.locationName,
            proximity: detectedBeacon.proximity,
            accuracy: detectedBeacon.accuracy,
            timestamp: Date()
        )
        
        do {
            let activity = try Activity.request(
                attributes: attributes,
                contentState: contentState)
            print("Started live activity \(activity.id)")
        } catch {
            print("Error starting live activity \(error.localizedDescription)")
        }
    }
}
