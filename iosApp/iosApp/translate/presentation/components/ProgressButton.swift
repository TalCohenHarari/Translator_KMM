//
//  ProgressButton.swift
//  iosApp
//
//  Created by Tal cohen harari on 07/04/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import shared

struct ProgressButton: View {
    var text: String
    var isLoading: Bool
    var onClick:()->Void
    
    var body: some View {
        Button(
            action:{
                if !isLoading {
                    onClick()
                }
            }
        ){
            if isLoading{
                ProgressView()
                    .padding(5)
                    .background(Color.primaryColor)
                    .cornerRadius(100)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else {
                Text(text.uppercased())
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .font(.body.weight(.bold))
                            .background(Color.primaryColor)
                            .foregroundColor(Color.onPrimary)
                            .cornerRadius(100)
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}

struct ProgressButton_Previews: PreviewProvider {
    static var previews: some View {
        ProgressButton(
            text: "translate",
            isLoading: false,
            onClick: {}
        )
    }
}
