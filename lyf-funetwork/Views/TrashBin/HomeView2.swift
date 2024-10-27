//
//  HomeView2.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI
import CoreLocation


// Update your HomeView to use this custom view
struct HomeView2: View {
    @StateObject private var beaconDetection = BeaconDetection.shared
    
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
//                VStack {
//                    Text("Current location: \(beaconDetection.detectedBeacon.locationName)")
//                    Text("Proximity: \(proximityString(beaconDetection.detectedBeacon.proximity))")
//                }
            }
            
            VStack {
                CustomDynamicIslandStyle(
                    locationName: beaconDetection.detectedBeacon.locationName.rawValue,
                    proximity: beaconDetection.detectedBeacon.proximity
                ).padding(.top, 14)
                
                
                Spacer()
            }
            .ignoresSafeArea()
        }
        .onAppear {
            beaconDetection.startMonitoring()
        }
    }
}

#Preview {
    HomeView2()
}
