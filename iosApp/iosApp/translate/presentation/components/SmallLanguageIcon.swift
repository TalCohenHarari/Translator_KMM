//
//  SmallLanguageIcon.swift
//  iosApp
//
//  Created by Tal cohen harari on 06/04/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import shared

struct SmallLanguageIcon: View {
    var language: UiLanguage
    
    var body: some View {
        Image(uiImage: UIImage(named: language.imageName.lowercased())!)
            .resizable()
            .frame(width: 40, height: 40)
    }
}

struct SmallLanguageIcon_Previews: PreviewProvider {
    static var previews: some View {
        SmallLanguageIcon(
            language: UiLanguage(language: .german, imageName: "german")
        )
    }
}
