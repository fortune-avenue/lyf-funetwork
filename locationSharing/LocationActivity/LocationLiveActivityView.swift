//
//  L.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct LocationLiveActivityView: View {
    let context: ActivityViewContext<LocationAttributes>
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("You're in")
                    .font(.system(size: 16))
                Text(context.state.locationName.rawValue)
                    .font(.system(size: 16, weight: .bold))
            }
            
            ProximityView(proximity: context.state.proximity)
            
            ShareButton()
        }
        .padding()
    }
}

// LocationActivityExtension/Views/ProximityView.swift
struct ProximityView: View {
    let proximity: String
    
    var body: some View {
        HStack {
            ProximityIndicator(proximity: proximity)
            Text(proximity)
                .font(.subheadline)
        }
    }
}

struct ProximityIndicator: View {
    let proximity: String
    
    var body: some View {
        Circle()
            .fill(getProximityColor(proximity))
            .frame(width: 12, height: 12)
    }
}

// LocationActivityExtension/Views/ShareButton.swift
struct ShareButton: View {
    var body: some View {
        Button(action: {
            // Handle share action via deep link
        }) {
            Text("Share Presence")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.blue))
        }
    }
}

// LocationActivityExtension/Utilities/ColorUtilities.swift
func getProximityColor(_ proximity: String) -> Color {
    switch proximity.lowercased() {
    case "immediate": return .green
    case "near": return .yellow
    case "far": return .red
    default: return .gray
    }
}
