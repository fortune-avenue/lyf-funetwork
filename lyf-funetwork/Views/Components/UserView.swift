//
//  UserView.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 28/10/24.
//

import SwiftUI

struct UserView: View {
    var name: String = "Hello, World!"
    var photoURL: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            Image("bubble_thoughts")
            AsyncImage(url: URL(string: photoURL)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.orange, lineWidth: 3))
                } else if phase.error != nil {
                    // Error loading the image
                    Image(systemName: "person.crop.circle.badge.exclamationmark")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.gray)
                } else {
                    // Placeholder while loading
                    ProgressView()
                        .frame(width: 36, height: 36)
                }
            }
        }
        .padding()
    }
}

#Preview {
    UserView(name: "Bernanda", photoURL: "https://qcmgdvvckpzlcrlavaee.supabase.co/storage/v1/object/public/photo/1.png")
}

