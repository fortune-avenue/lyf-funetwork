//
//  MapDetailCard.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 28/10/24.
//

import SwiftUI

struct MapDetailCard: View {
    @State var isModal0Presented = false
    @State var isModalAPresented = false
    @State var isModalBPresented = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Text("Popular times at \(Date.now.formatted(.dateTime.weekday(.wide)))")
                        .font(.headline)
                        .padding(.leading, 16)
                    Spacer()
                }.padding(.top, 16)
                
                PopularTimesGraph()
                
                // Booking Button
                Button(action: {
                    isModal0Presented = true
                }) {
                    Text("Booking Meeting Room")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.primary))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // Upcoming Event Section
                VStack(alignment: .leading, spacing: 8) {
                    
                    HStack {
                        Text("Upcoming Event!")
                            .font(.headline)
                        Spacer()
                        Button("View All") {
                            // Handle view all action
                        }
                        .font(.caption)
                    }
                    
                    EventCard(
                            image: Image("halowen"), // Replace with actual image
                            title: "Halloween Party",
                            description: "Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet",
                            date: "31 Oct 2024",
                            time: "19:00 - 21:30"
                    ).onTapGesture {
                        isModalAPresented = true
                    }
                    
                }.padding()
                
                
                // Shared Space Forum Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Shared Space Forum")
                            .font(.headline)
                        Spacer()
                        Button("View All") {
                            isModalBPresented = true
                        }
                        .font(.caption)
                    }
                    
                    VStack(spacing: 12) {
                        ForumPost(title: "Halloween Party?", content: "Hi guys! is there any people in Lyf Funan wanna come and join..", comments: 4, timeAgo: "2h ago")
                        ForumPost(title: "Cosplay?", content: "Hi guys! is there any people in Lyf Funan wanna come and join..", comments: 4, timeAgo: "2h ago")
                    }
                }.padding()
            }
            .sheet(isPresented: $isModal0Presented) {
                BookingFormView()
                    .presentationDetents([.fraction(0.8)])
            }
            .sheet(isPresented: $isModalAPresented) {
                EventCardExpanded()
                    .presentationDetents([.medium])
            }
            .sheet(isPresented: $isModalBPresented) {
                ForumCardExpanded(isExpanded: $isModalBPresented)
                    .presentationDetents([.medium])
                    
            }
            .background(.white)
            .cornerRadius(12)
            .padding()
        }
    }
}

struct EventCardExpanded: View {
    var body: some View {
        VStack(spacing: 16) {
            Image("haloween_event")
                .resizable()
                .scaledToFit()
                .padding()
                .padding(.top)
            
            Button(action: {
            }) {
                Text("Join Event")
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
}

struct ForumCardExpanded: View {
    @EnvironmentObject var r : Router
    @Binding var isExpanded: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Forum").font(.title2).fontWeight(.bold)
                Spacer()
                Image(systemName: "plus")
                    .foregroundStyle(Color(.primary))
            }
            .padding(.top, 36)
            
            VStack(spacing: 12) {
                ForumPost(title: "Halloween Party?", content: "Hi guys! is there any people in Lyf Funan wanna come and join..", comments: 4, timeAgo: "2h ago").onTapGesture {
                    isExpanded = false
                    r.navigate(to: .forum)
                }
                ForumPost(title: "Cosplay?", content: "Hi guys! is there any people in Lyf Funan wanna come and join..", comments: 4, timeAgo: "2h ago")
                ForumPost(title: "Trick or Treat!", content: "Hi guys! is there any people in Lyf Funan wanna come and join..", comments: 4, timeAgo: "2h ago")
                ForumPost(title: "Where do i found the Table?", content: "Hi guys! is there any people in Lyf Funan wanna come and join..", comments: 4, timeAgo: "2h ago")
            }
            
        }
        .padding(.horizontal)
    }
}

struct PopularTimesGraph: View {
    let heights: [CGFloat] = [20, 35, 55, 65, 50, 70, 45, 30]
    let times = ["6a", "9a", "12p", "3p", "6p", "9p", "12a"]
    
    var body: some View {
        VStack(spacing: 4) {
            // Graph
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<8, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 6)
                        .fill(index == 5 ? Color(.primary) : Color(.accentOff))
                        .frame(width: 30, height: heights[index])
                }
            }
            .frame(height: 70)
            
            // Time axis
            HStack(spacing: 10) {
                ForEach(times, id: \.self) { time in
                    Text(time)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .frame(width: 30)
                }
            }
        }
    }
}

struct EventCard: View {
    var image: Image
    var title: String
    var description: String
    var date: String
    var time: String

    var body: some View {
        HStack(alignment: .top) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.leading, 8)
                .padding(.trailing, 16)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Text(description)
                    .font(.caption)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Label(date, systemImage: "calendar")
                    Label(time, systemImage: "clock")
                }
                .font(.caption2)
                .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6)) // Light gray background
        .cornerRadius(12) // Rounded edges
    }
}

struct ForumPost: View {
    var title: String
    var content: String
    var comments: Int
    var timeAgo: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
            Text(content)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack {
                Label("\(comments)", systemImage: "bubble.left.and.bubble.right")
                Text(timeAgo)
            }
            .font(.caption2)
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    MapDetailCard()
}
