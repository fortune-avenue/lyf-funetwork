import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject private var beaconDetection = BeaconDetection.shared
    @State private var isExpanded = false
    @State private var rippleIntensity: Int = 3
    @State private var color = Color(.primary)
//
//    var rippleIntensity : Int {
//        beaconDetection.detectedBeacon.accuracy
//    }
    
    var body: some View {
        ZStack {
            // Background image
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            // Top controls
            VStack {
                HStack(alignment: .top) {
                    VStack {
                        CircleButton(iconName: "bell.fill", foregroundColor: .black) {
                            print("Notification tapped")
                        }
                        .padding(.bottom, 16)
                        
//                        CircleButton(iconName: "location.fill", foregroundColor: .black) {
//                            print("Location tapped")
//                        }
                    }
                    
                    Spacer()
                    
                    CircleButton(iconName: "person.fill", foregroundColor: .black) {
                        print("Profile tapped")
                    }
                }
                .padding(24)
                
                Spacer()
            }
            
            // Main content
            VStack {
                Spacer()
                
                MapView()
                
                Spacer()
            }
            
            SunView(isExpanded: isExpanded, color: $color, rippleIntensity: $rippleIntensity)
                .environmentObject(beaconDetection)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            if value.translation.height < 0 {
                                // Swiped up
                                isExpanded = true
                            } else if value.translation.height > 0 {
                                // Swiped down
                                isExpanded = false
                            }
                        }
                )
                .position(x: UIScreen.main.bounds.width / 2, y: isExpanded ? UIScreen.main.bounds.height + 100 : UIScreen.main.bounds.height + 200)
                .animation(.spring(), value: isExpanded)
        }
        .onAppear {
            beaconDetection.startMonitoring()
        }
    }
    
    private func colorForLocation(_ location: LocationEnum) -> Color {
        return .red
    }
}

struct SunView: View {
    @EnvironmentObject var beacon : BeaconDetection
    let isExpanded: Bool
    @Binding var color: Color
    @Binding var rippleIntensity: Int
    @State private var animateRipple = false
    
    var body: some View {
        ZStack {
            VStack {
                
            }
            Circle()
                .fill(color.opacity(1))
                .frame(width: 700, height: 700)
                .ignoresSafeArea()
            
            // Layered ripple effect
            ForEach(0..<rippleIntensity, id: \.self) { index in
                Circle()
                    .fill(color.opacity(0.4 - Double(index) * 0.1))
                    .frame(width: CGFloat(700 + index * 50), height: CGFloat(700 + index * 50))
                    .scaleEffect(animateRipple ? 1.3 : 1)
                    .opacity(animateRipple ? 0 : 1)
                    .animation(
                        Animation.easeOut(duration: 2)
                            .delay(Double(index) * 0.4)
                            .repeatForever(autoreverses: false)
                    )
            }
            .onAppear {
                animateRipple.toggle()
            }
        }.onAppear {
            Task {
                if (beacon.detectedBeacon.locationName == .none) {
                    color = .gray
                }
            }
        }
    }
}


#Preview {
    HomeView()
}
