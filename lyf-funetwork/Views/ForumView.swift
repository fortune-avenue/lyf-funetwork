//
//  ForumView.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 29/10/24.
//

import SwiftUI

struct ForumView: View {
    @EnvironmentObject var router : Router
    
    var body: some View {
        ZStack {
            Image("background").resizable()
            
            
            Image("chat")
                .resizable()
                .scaledToFit().padding()
            
            VStack(alignment: .center) {
                ZStack {
                    // Background image
                    Image("chat_top")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                    
                    // Overlay content
                    HStack {
                        // Back button
                        Button(action: {
                            router.navigateBack()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 4) {
                            Text("Halloween Party?")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("Co-working Forum")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer() // To center the text with back button alignment
                    }
                    .padding(.horizontal)
                    .padding(.top, 50) // Adjust to give space at the top if needed
                }
                .ignoresSafeArea()
                .frame(height: 100) // Adjust height to fit the design
                
                
                Spacer()
                
                Image("chat_dock").resizable().scaledToFit().ignoresSafeArea()
            }
            
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    ForumView()
}
