//
//  MapDetailView.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI
import Combine

struct MapDetailView: View {
    var location: LocationAsset
    @State private var userLocations: [User]? = nil
    @State private var counter: Int = 0
    private var supa = Supa.shared
    private var cancellables = Set<AnyCancellable>()
    
    init(location: LocationAsset) {
        self.location = location
    }
    
    var body: some View {
        ZStack {
            Image("background").resizable()
            
            BackButton()
            
            VStack {
                GeometryReader { geometry in
                    Image(locationImage)
                        .resizable()
                        .scaledToFit()
                        .padding(24)
                        .padding(.top, 16)
                        .overlay {
                            if let userLocations = userLocations {
                                ForEach(userLocations, id: \.self) { userLocation in
                                    UserView(name: userLocation.name, photoURL: userLocation.photo_profile)
                                }
                            }
                        }
                }
                Spacer()
            }
            
            VStack {
                Spacer().frame(height: 240)
                HStack {
                    PersonCounterView(location: location, count: $counter)
                        .padding(.leading, 20)
                        .padding(.top, 48)
                    Spacer()
                }
                
                MapDetailCard()
            }
            
        }
        .onAppear {
            // Simulate the delayed appearance of the user view and counter increment
            if (location != .lounge) {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.userLocations = [User(name: "John Doe", photo_profile:  "https://qcmgdvvckpzlcrlavaee.supabase.co/storage/v1/object/public/photo/1.png")]
                self.counter += 1
            }
        }
        .background(.gray.opacity(0.1))
        .navigationBarBackButtonHidden(true)
    }
    
    var locationImage: String {
        switch location {
        case .gym: return "gym"
        case .kitchen: return "kitchen"
        case .lounge: return "lounge"
        case .laundry: return "laundry_front"
        case .all: return ""
        }
    }
}

struct PersonCounterView: View {
    var location: LocationAsset
    @Binding var count: Int
    @State var capacity: Int = 10
    
    var body: some View {
        HStack {
            Image(systemName: "person.fill")
                .foregroundColor(.white)
            
            Text("\(count)/\(capacity)")
                .foregroundColor(.white)
                .fontWeight(.bold)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.primary))
                .frame(width: 80, height: 40)
        )
        .foregroundColor(.white)
    }
}

#Preview {
    MapDetailView(location: .lounge)
}
