//
//  Location.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

// LocationActivityExtension/LocationActivityLiveActivity.swift
import ActivityKit
import WidgetKit
import SwiftUI

import ActivityKit
import WidgetKit
import SwiftUI

struct LocationActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LocationAttributes.self) { context in
            // Expanded view when tapped
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(getProximityColor(context.state.proximity))
                    
                    Text("You're in")
                        .font(.subheadline)
                    Text(context.state.locationName.rawValue)
                        .font(.headline)
                }
                
                Button("Share Presence") {
                    // Handle share action through URL scheme or deep link
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.blue))
            }
            .padding()
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded layout
                DynamicIslandExpandedRegion(.leading) {
                    Label(context.state.locationName.rawValue,
                          systemImage: "location.fill")
                        .font(.headline)
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.proximity)
                        .font(.subheadline)
                        .foregroundColor(getProximityColor(context.state.proximity))
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Button("Share Location") {
                        // Handle share action
                    }
                    .frame(maxWidth: .infinity)
                }
            } compactLeading: {
                // Minimal leading view
                HStack {
                    Image(systemName: "location.fill")
                    Text(context.state.locationName.rawValue)
                        .font(.caption)
                        .lineLimit(1)
                }
            } compactTrailing: {
                // Minimal trailing view
                Circle()
                    .fill(getProximityColor(context.state.proximity))
                    .frame(width: 14, height: 14)
            } minimal: {
                // Ultra-minimal view
                Image(systemName: "location.fill")
                    .foregroundColor(getProximityColor(context.state.proximity))
            }
        }
    }
    
    private func getProximityColor(_ proximity: String) -> Color {
        switch proximity {
        case "Immediate": return .green
        case "Near": return .yellow
        case "Far": return .red
        default: return .gray
        }
    }
}
