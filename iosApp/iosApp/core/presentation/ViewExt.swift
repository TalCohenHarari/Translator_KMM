//
//  ViewExt.swift
//  iosApp
//
//  Created by Tal cohen harari on 11/04/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder
    func removeTextEditorBackground() -> some View {
        if #available(iOS 16, *) {
            self.scrollContentBackground(.hidden)
        }else{
            self.onAppear{
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
