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
    
    @State private var isPressed = false
    
    init(iconName: String, foregroundColor: Color = .white, fillColor: Color = Color(.primary), action: @escaping () -> Void) {
        self.iconName = iconName
        self.foregroundColor = foregroundColor
        self.fillColor = fillColor
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeIn(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            ZStack {
                // Solid black shadow circle
                Circle()
                    .fill(Color.black)
                    .offset(x: 0, y: 6)
                
                // Main colored button
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(foregroundColor)
                    .padding()
                    .background(Circle().fill(fillColor))
                    .offset(y: isPressed ? 6 : 0)
            }
        }
        .frame(width: 54, height: 54) // Slightly larger to accommodate shadow
        .buttonStyle(PlainButtonStyle())
    }
}

struct MyButton: View {
    let text: String?
    let iconName: String?
    let foregroundColor: Color
    let fillColor: Color
    var action: () -> Void
    
    @State private var isPressed = false
    
    init(text: String?, iconName: String?, foregroundColor: Color = .white, fillColor: Color = Color(.primary), action: @escaping () -> Void) {
        self.text = text
        self.iconName = iconName
        self.foregroundColor = foregroundColor
        self.fillColor = fillColor
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.easeIn(duration: 0.1)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeOut(duration: 0.1)) {
                    isPressed = false
                }
                action()
            }
        }) {
            ZStack {
                // Solid black shadow shape
                HStack(spacing : 5) {
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
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black)
                        .offset(x: 0, y: 7)
                    
                )
                
                
                // Main colored button
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
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(fillColor)
                )
                .offset(y: isPressed ? 7 : 0) // Move to shadow position when pressed
            }
        }
        .frame(height: 48)
        .buttonStyle(PlainButtonStyle())
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

