//
//  HomeView.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI
import CoreLocation
import ActivityKit

struct HomeView: View {
    @StateObject private var beaconDetection = BeaconDetection.shared
    @State private var currentActivity: Activity<LocationAttributes>? = nil
    @State private var selectedAsset: LocationAsset = .all
    @State private var isModalPresented: Bool = false
    @EnvironmentObject var router : Router
    @State private var statusText: String = ""
    var userUC = UserUseCase.shared
    
    
    var body: some View {
        ZStack {
            Image("background").resizable()
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    Image("logo")
                        .resizable()
                        .frame(maxWidth: 52, maxHeight: 52)
                        .padding()
                    
                    Spacer()
                    
                    CustomToggleButton(onText: "Shareloc", offText: "Anonymous")
                }
                .padding(.top, 12)
                .padding(.horizontal, 24)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                MapView(selectedAsset: $selectedAsset)
                    .padding(.bottom, 21)
                
                VStack(alignment: .center) {
                    if (beaconDetection.detectedBeacon.locationName == .none) {
                        Text("You're not detected in any spaces")
                        Text("Let's explore Lyf!")
                            .font(.title)
                            .fontWeight(.bold)
                    } else {
                        Text("You're in")
                        Text("\(beaconDetection.detectedBeacon.locationName.rawValue)")
                            .multilineTextAlignment(.center)
                            .fontWeight(.bold)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    TextField("Share your thoughts here...", text: $statusText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 48)
                }
                Spacer()
            }
        }
        .background(Color(.bg))
        .onChange(of: selectedAsset, {
            if(selectedAsset != .all) {
                isModalPresented = true
            }
        })
        .sheet(isPresented: $isModalPresented) {
            LocationDetailModal(locationName: selectedAsset, isModalActive: $isModalPresented)
                .presentationDetents([.height(240)])
                .environmentObject(router)
        }
        .onAppear {
            beaconDetection.startMonitoring()
            beaconDetection.detectedBeacon.locationName = .coworkingA
            startOrUpdateLiveActivity()
        }
        .onChange(of: beaconDetection.detectedBeacon.locationName) {
            updateLiveActivity()
            
            Task {
                await userUC.getUserLocation()
            }
        }
        
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
                    proximity: beaconDetection.detectedBeacon.proximity,
                    accuracy: beaconDetection.detectedBeacon.accuracy,
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
                proximity: beaconDetection.detectedBeacon.proximity,
                accuracy: beaconDetection.detectedBeacon.accuracy,
                timestamp: Date()
            )
            
            for activity in Activity<LocationAttributes>.activities {
                await activity.update(using: updatedState)
            }
        }
    }
}



#Preview {
    RootView().environmentObject(Router())
}
