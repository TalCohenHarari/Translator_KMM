//
//  GradientSurface.swift
//  iosApp
//
//  Created by Tal cohen harari on 07/04/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import shared

// @Environment(\.colorScheme) = to get the current dark or light theme
// content = returns view
struct GradientSurface:ViewModifier{
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        if colorScheme == .dark{
            let gradientStart = Color(hex: 0xFF23262E)
            let gradientEnd = Color(hex: 0xFF212329)
            
            content
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [gradientStart,gradientEnd]),
                        startPoint: .top ,
                        endPoint: .bottom
                    )
                )
        }else{
            content.background(Color.surface)
        }
    }
}

//Extension function for custom Modifier
extension View {
    func gradientSurface() -> some View{
        modifier(GradientSurface())
    }
}
