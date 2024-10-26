//
//  HomeView.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject private var beaconDetection = BeaconDetection.shared
    
    
    var body: some View {
        ZStack {
            Image("background").resizable()
            VStack {
                HStack {
                    CircleButton(iconName: "bell.fill", foregroundColor: .black) {
                        print("to notification")
                    }
                    .padding()
                    
                    
                    Spacer()
                    
                    CircleButton(iconName: "person.fill", foregroundColor: .black) {
                        print("to notification")
                    }
                    .padding()
                    
                }.padding(.horizontal, 16)
                
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
}

#Preview {
    HomeView()
}
