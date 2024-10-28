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
import CoreLocation

struct LocationActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LocationAttributes.self) { context in
            VStack(spacing: 12) {
                HStack {
                    Image("lyfOutline")
                        .resizable()
                        .frame(maxWidth: 24, maxHeight: 24)
                        .padding(.leading, 8)
                    
                    if (context.state.locationName != .none) {
                        Text("You're in")
                            .font(.subheadline)
                        Text(context.state.locationName.rawValue)
                            .font(.headline)
                            .fontWeight(.semibold)
                    } else {
                        Text("You're not detected anywhere. Try to mingle? 👀")
                            .font(.subheadline)
                    }
                   
                    
                    Spacer()
                    
                    Circle()
                        .fill(getProximityColor(context.state.proximity))
                        .frame(width: 14, height: 14)
                        .padding(.trailing, 8)
                }
            }
            .padding()
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded layout
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Image("lyfOutline")
                            .resizable()
                            .frame(maxWidth: 16, maxHeight: 16)
                            .padding(.leading, 6)
                        
                        if (context.state.locationName != .none) {
                            Text("in")
                                .font(.caption)
                                .lineLimit(1)
                            
                            Text(context.state.locationName.rawValue)
                                .fontWeight(.bold)
                        } else {
                            Text("Unknown")
                                .font(.caption)
                                .lineLimit(1)
                        }
                       
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Circle()
                        .fill(getProximityColor(context.state.proximity))
                        .frame(width: 18, height: 18)
                        .padding(.trailing, 6)
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text("Someone can see your presence in here!")
                            .font(.subheadline)
                            
                        Spacer()
                        Image(systemName: "arrow.forward")
                            .foregroundStyle(.orange)
                            
                    }
                    .padding(6)
                    
                }
            } compactLeading: {
                // Minimal leading view
                HStack {
                    Image("lyfOutline")
                        .resizable()
                        .frame(maxWidth: 16, maxHeight: 12)
                        .padding(.leading, 2)
                    
                    if context.state.locationName != .none {
                        
                        Text(context.state.locationName.rawValue)
                            .font(.caption)
                            .lineLimit(1)
                    }
                    
                }
            } compactTrailing: {
                // Minimal trailing view
                Circle()
                    .fill(getProximityColor(context.state.proximity))
                    .frame(width: 14, height: 14)
                    .padding(.trailing, 2)
            } minimal: {
                Image(systemName: "location.fill")
                    .foregroundColor(getProximityColor(context.state.proximity))
            }
                
        }
    }
    
    private func getProximityColor(_ proximity: CLProximity) -> Color {
        switch proximity {
        case .immediate: return .orange
        case .near: return .orange
        case .far: return .yellow
        default: return .gray
        }
    }
}

