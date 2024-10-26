//
//  Button.swift
//  lyf-funetwork
//
//  Created by mac.bernanda on 26/10/24.
//

import SwiftUI

struct CircleButton: View {
    let iconName: String
    let foregroundColor: Color
    let fillColor: Color
    var action: () -> Void
    
    init(iconName: String, foregroundColor: Color = .white, fillColor: Color = .orange, action: @escaping () -> Void) {
        self.iconName = iconName
        self.foregroundColor = foregroundColor
        self.fillColor = fillColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20) // Size of the SF Symbol
                .foregroundColor(foregroundColor)
                .padding()
                .background(Circle().fill(fillColor)) // Circle background
        }
        .frame(width: 50, height: 50) // Outer frame to keep the touch area larger
    }
}

struct MyButton: View {
    let text: String?
    let iconName: String?
    let foregroundColor: Color
    let fillColor: Color
    var action: () -> Void
    
    init(text: String?, iconName: String?, foregroundColor: Color = .white, fillColor: Color = .orange, action: @escaping () -> Void) {
        self.text = text
        self.iconName = iconName
        self.foregroundColor = foregroundColor
        self.fillColor = fillColor
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if let text = text {
                    Text(text)
                        .foregroundColor(foregroundColor)
                        .font(.body)
                }
                if let iconName = iconName {
                    Image(systemName: iconName)
                        .foregroundColor(foregroundColor)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(fillColor))
        }
    }
}

struct DisplayButton: View {
    var body: some View {
        VStack(spacing: 20) {
            // Example of CircleButton
            CircleButton(iconName: "bell.fill", foregroundColor : Color.black) {
                print("Circle button tapped")
            }
            
            // Example of MyButton with only text
            MyButton(text: "Click Me", iconName: nil) {
                print("MyButton with text tapped")
            }
            
            // Example of MyButton with only icon
            MyButton(text: nil, iconName: "star.fill") {
                print("MyButton with icon tapped")
            }
            
            // Example of MyButton with both text and icon
            MyButton(text: "Favorite", iconName: "star.fill") {
                print("MyButton with text and icon tapped")
            }
        }
        .padding()
    }
}

#Preview {
    DisplayButton()
}

