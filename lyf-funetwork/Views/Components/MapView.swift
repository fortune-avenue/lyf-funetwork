//
//  MapView.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI

enum LocationAsset: String, CaseIterable {
    case all = "hotel_all"
    case gym = "hotel_gym"
    case kitchen = "hotel_kitchen"
    case lounge = "hotel_lounge"
    case laundry = "hotel_laundry"
    
    var title: String {
        self.rawValue
    }
}

struct MapView: View {
    @State private var selectedAsset: LocationAsset = .all
    
    var body: some View {
            VStack {
                GeometryReader { geometry in
                    Image(selectedAsset.title)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .onTapGesture {
                            selectedAsset = .all
                        }.overlay {
                            // Overlay touchable circles for each asset except .all
                            ForEach(LocationAsset.allCases.filter { $0 != .all }, id: \.self) { asset in
                                CircleView()
                                    .position(position(for: asset, in: geometry.size))
                                    .onTapGesture {
                                        selectedAsset = asset
                                    }
                            }
                        }
                }.frame(height: 420)
            }
    }
    
    // Define positions for each asset circle
    private func position(for asset: LocationAsset, in size: CGSize) -> CGPoint {
        switch asset {
        case .gym:
            return CGPoint(x: size.width * 0.2, y: size.height * 0.3)
        case .kitchen:
            return CGPoint(x: size.width * 0.2, y: size.height * 0.5)
        case .lounge:
            return CGPoint(x: size.width * 0.2, y: size.height * 0.7)
        case .laundry:
            return CGPoint(x: size.width * 0.45, y: size.height * 0.85)
        case .all:
            return CGPoint.zero // Not used, but required to satisfy switch cases
        }
    }
}

#Preview {
    MapView()
}

struct CircleView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 40)
            
            // Smaller white circle centered within the touch area
            Circle()
                .fill(Color.white)
                .frame(width: 15, height: 15)
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 2)
                )
        }
    }
}


