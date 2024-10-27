//
//  HomeView.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI
import CoreLocation
import ActivityKit

struct HomeView1: View {
    @StateObject private var beaconDetection = BeaconDetection.shared
    @State private var currentActivity: Activity<LocationAttributes>? = nil
    
    var body: some View {
        ZStack {
            Image("background").resizable()
            VStack {
                HStack(alignment: .top) {
                    VStack {
                        CircleButton(iconName: "bell.fill", foregroundColor: .black) {
                            print("to notification")
                        }.padding(.bottom, 16)
                        
                        CircleButton(iconName: "location.fill", foregroundColor: .black) {
                            print("to notification")
                        }
                    }
                    
                    Spacer()
                    
                    CircleButton(iconName: "person.fill", foregroundColor: .black) {
                        print("to notification")
                    }
                }
                .padding(24)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                MapView()
                
                Spacer()
                VStack {
                    Text("Current location: \(beaconDetection.detectedBeacon.locationName)")
                    Text("Proximity: \(proximityString(beaconDetection.detectedBeacon.proximity))")
                }
            }
        }
        .onAppear {
            beaconDetection.startMonitoring()
//            startOrUpdateLiveActivity()
        }
//        .onChange(of: beaconDetection.detectedBeacon.locationName) {
//            updateLiveActivity()
//        }
    }
    
    private func proximityString(_ proximity: CLProximity) -> String {
        switch proximity {
        case .immediate: return "Immediate"
        case .near: return "Near"
        case .far: return "Far"
        case .unknown: return "Unknown"
        @unknown default: return "Unknown"
        }
    }
    
    private func startOrUpdateLiveActivity() {
        Task {
            // Check if there's an existing activity
            if let existingActivity = Activity<LocationAttributes>.activities.first {
                currentActivity = existingActivity
                updateLiveActivity()
            } else {
                // Start new activity if none exists
                let attributes = LocationAttributes(userName: "User")
                let contentState = LocationAttributes.ContentState(
                    locationName: beaconDetection.detectedBeacon.locationName,
                    proximity: proximityString(beaconDetection.detectedBeacon.proximity),
                    timestamp: Date()
                )
                
                do {
                    let activity = try Activity.request(
                        attributes: attributes,
                        contentState: contentState
                    )
                    currentActivity = activity
                    print("Started live activity \(activity.id)")
                } catch {
                    print("Error starting live activity \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func updateLiveActivity() {
        Task {
            let updatedState = LocationAttributes.ContentState(
                locationName: beaconDetection.detectedBeacon.locationName,
                proximity: proximityString(beaconDetection.detectedBeacon.proximity),
                timestamp: Date()
            )
            
            for activity in Activity<LocationAttributes>.activities {
                await activity.update(using: updatedState)
            }
        }
    }
}

#Preview {
    HomeView()
}
