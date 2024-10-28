//
//  BookView.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 29/10/24.
//

import SwiftUI

struct BookingFormView: View {
    @State private var selectedRoomType: String? = "Connect"
    @State private var amenitiesRequest: String = ""
    @State private var selectedDate: Date = Date()
    @State private var selectedTimes: Set<String> = []
    private let roomTypes = ["Connect", "Meet", "Collab"]
    private let times = ["12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Fill Booking Information")
                .font(.title2).bold()
                .padding(.top, 48)
            
            Text("Room Type:")
                .font(.headline)
            
            HStack(spacing: 16) {
                ForEach(roomTypes, id: \.self) { room in
                    Button(action: {
                        selectedRoomType = room
                    }) {
                        Text(room)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedRoomType == room ? Color(.primary) : Color.gray.opacity(0.1))
                            .foregroundColor(selectedRoomType == room ? .white : .black)
                            .cornerRadius(12)
                    }
                }
            }
            
            Text("Request Amenities?")
                .font(.headline)
            
            TextField("What’s your needs using Meeting Room", text: $amenitiesRequest)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            Text("Date")
                .font(.headline)
            
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            
            Text("Time")
                .font(.headline)
            
            VStack(spacing: 8) {
                let firstRowTimes = Array(times.prefix(times.count / 2))
                let secondRowTimes = Array(times.suffix(times.count / 2))
                
                HStack(spacing: 8) {
                    ForEach(firstRowTimes, id: \.self) { time in
                        Button(action: {
                            toggleSelection(for: time)
                        }) {
                            Text(time)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTimes.contains(time) ? Color(.primary) : Color.gray.opacity(0.1))
                                .foregroundColor(selectedTimes.contains(time) ? .white : .black)
                                .cornerRadius(12)
                        }
                    }
                }
                
                HStack(spacing: 8) {
                    ForEach(secondRowTimes, id: \.self) { time in
                        Button(action: {
                            toggleSelection(for: time)
                        }) {
                            Text(time)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTimes.contains(time) ? Color(.primary) : Color.gray.opacity(0.1))
                                .foregroundColor(selectedTimes.contains(time) ? .white : .black)
                                .cornerRadius(12)
                        }
                    }
                }
            }.padding(.bottom, 24)
            
            Button(action: {
                // Booking action
            }) {
                Text("Booking Meeting Room")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.primary))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }.padding(.bottom, 24)
        }
        .padding()
    }
    
    private func toggleSelection(for time: String) {
        if selectedTimes.contains(time) {
            selectedTimes.remove(time)
        } else {
            selectedTimes.insert(time)
        }
    }
}

#Preview {
    BookingFormView()
}
