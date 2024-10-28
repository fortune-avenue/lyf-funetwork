import SwiftUI

struct CustomToggleButton: View {
    @State private var isOn: Bool = false
    var onText: String = "On"
    var offText: String = "Off"
    
    var body: some View {
        // Toggle button
        ZStack {
            // Background of the toggle with rounded corners
            RoundedRectangle(cornerRadius: 20)
                .fill(isOn ? Color(.primary) : Color("accentOff"))
                .frame(width: 128, height: 40)
                .overlay(
                    HStack {
                        Text(isOn ? onText : offText)
                            .font(.caption)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .animation(nil)
                            .padding(.leading, isOn ? 12 : 46)
                        
                        Spacer()
                    }
                )
            
            
            // Sliding circle
            Circle()
                .fill(isOn ? Color(.accentOff) : Color(.primary))
                .frame(width: 32, height: 32)
                .offset(x: isOn ? 42 : -42)
                .animation(.easeInOut(duration: 0.2), value: isOn)
        }
        .onTapGesture {
            isOn.toggle()
        }
    }
}

#Preview {
    CustomToggleButton(onText: "Shareloc", offText: "Anonymous")
}
