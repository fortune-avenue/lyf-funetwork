//
//  CustomDynamicIsland.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI
import CoreLocation

struct CustomDynamicIslandStyle: View {
    let locationName: String
    let proximity: CLProximity
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            // Compact and expanded views combined
            ZStack {
                // Expanded view (appears only when isExpanded is true)
                if isExpanded {
                    expandedView
                        .transition(.opacity.combined(with: .scale(scale: 0.85)))
                } else {
                    compactView
                        .transition(.opacity)
                }
            }
            .frame(width: isExpanded ? 320 : 200, height: isExpanded ? 160 : 38)
            .background(Color.black)
            .clipShape(Capsule())
            .onTapGesture {
                withAnimation(.spring()) {
                    isExpanded.toggle()
                }
            }
        }
    }
    
    // Compact view
    private var compactView: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "location.fill")
                Text(locationName)
                    .font(.caption)
                    .lineLimit(1)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Circle()
                .fill(getProximityColor(proximity))
                .frame(width: 14, height: 14)
                .padding(.trailing, 8)
        }
        .padding(.horizontal, 8)
    }
    
    // Expanded view
    private var expandedView: some View {
        VStack(spacing: 12) {
            HStack {
                Text("You're in")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(locationName)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            
            Text("H")
            Button("Share Presence") {
                // Handle share action
            }
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.blue))
        }
        .padding()
        .background(Color.black.opacity(0.8))
        .padding(.horizontal)
    }
    
    private func getProximityColor(_ proximity: CLProximity) -> Color {
        switch proximity {
        case .immediate: return .green
        case .near: return .yellow
        case .far: return .red
        case .unknown: return .gray
        @unknown default: return .gray
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
    CustomDynamicIslandStyle(locationName: "Hotel Lobby", proximity: .near)
}
