//
//  LocationInfoModal.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 28/10/24.
//

import SwiftUI

struct LocationDetailModal: View {
    var locationName: LocationAsset
    @Binding var isModalActive: Bool
    @EnvironmentObject var router : Router
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(getTitle)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.horizontal)
                
                Spacer()
            }
            
            Text(getInfo)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 12)
                
            Spacer()
                .frame(height: 16)
            
            Button(action: {
                print(locationName)
                isModalActive.toggle()
                switch locationName {
                case .gym: router.navigate(to: .gym)
                case .kitchen: router.navigate(to: .kitchen)
                case .lounge: router.navigate(to: .lounge)
                case .laundry: router.navigate(to: .laundry)
                case .all: return
                }
                
            }) {
                Text("Events, Forum & Booking Here!")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.primary))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }.padding(.horizontal)
            
        }
        .padding(.horizontal)
    }
    
    
    var getTitle : String {
        switch locationName {
        case .gym:
            return "BURN - SOCIAL GYM"
        case .all:
            return ""
        case .kitchen:
            return "BOND - SOCIAL KITCHEN"
        case .lounge:
            return "CONNECT - COWORKING LOUNGE"
        case .laundry:
            return "WASH AND HANG - LAUNDERETTE"
        }
    }
    
    var getInfo : String {
        switch locationName {
        case .gym:
            return "Work up a sweat in lyf's life-sized giant hamster wheel that functions as a quirky treadmill, or train up your core with our TRX bands. Gym-ing has never been so fun!"
        case .all:
            return ""
        case .kitchen:
            return "Dreary chores are a thing of the past. Load your laundry, then read, chat or chill with a beer while your clothes get cleaned."
        case .lounge:
            return "Get comfy in the communal lounge: work if you must, but if it’s a break you’re after, there are indulgent couches to chill in and open spaces to work from."
        case .laundry:
            return "Dreary chores are a thing of the past. Load your laundry, then read, chat or chill with a beer while your clothes get cleaned."
        }
    }
    
}
#Preview {
    LocationDetailModal(locationName: .gym, isModalActive: .constant(true))
}
