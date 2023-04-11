//
//  TranslateTextField.swift
//  iosApp
//
//  Created by Tal cohen harari on 07/04/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import shared
import UniformTypeIdentifiers

//@Binding = In android we have onValueChange, here this annotation change without any callback the value of the textField
struct TranslateTextField: View {
    @Binding var fromText: String
    let toText: String?
    let isTranslating: Bool
    let fromLanguage: UiLanguage
    let toLanguage: UiLanguage
    let onTranslateEvent: (TranslateEvent) -> Void
    
    var body: some View {
        if toText == nil || isTranslating {
            IdleTextField(
                fromText: $fromText,
                isTranslating: isTranslating,
                onTranslateEvent: onTranslateEvent
            )
            .gradientSurface()
            .cornerRadius(15)
            .animation(.easeInOut, value: isTranslating)
            .shadow(radius: 4)
        }else{
            TranslatedTextField(
                fromText: fromText,
                toText: toText ?? "",
                fromLanguage: fromLanguage,
                toLanguage: toLanguage,
                onTranslateEvent: onTranslateEvent
            )
            .padding()
            .gradientSurface()
            .cornerRadius(15)
            .animation(.easeInOut, value: isTranslating)
            .shadow(radius: 4)
            .onTapGesture {
                onTranslateEvent(TranslateEvent.EditTranslation())
            }
        }
    }
}

struct TranslateTextField_Previews: PreviewProvider {
    static var previews: some View {
        TranslateTextField(
            fromText: Binding(
                get: { "test" },
                set: { value in }
            ),
            toText: "Test",
            isTranslating: false,
            fromLanguage: UiLanguage(language: .english, imageName: "english"),
            toLanguage: UiLanguage(language: .german, imageName: "german"),
            onTranslateEvent: { event in }
        )
        .preferredColorScheme(.dark)
        .previewInterfaceOrientation(.portraitUpsideDown)
    }
}

// $fromText reffer to the value of this field
// overlay = like a box that the content on the top of this view, just as a box modifier
private extension TranslateTextField {
    struct IdleTextField: View {
        @Binding var fromText: String
        let isTranslating: Bool
        let onTranslateEvent: (TranslateEvent) -> Void

        var body: some View{
            TextEditor(text: $fromText)
                .frame(
                    maxWidth: .infinity,
                    minHeight: 200,
                    alignment: .topLeading
                )
                .padding()
                .foregroundColor(Color.onSurface)
                .overlay(alignment: .bottomTrailing, content: {
                        ProgressButton(
                            text: "Translate",
                            isLoading: isTranslating,
                            onClick:{ onTranslateEvent(TranslateEvent.Translate())}
                        )
                        .padding(.trailing)
                        .padding(.bottom)
                    }
                )
                .removeTextEditorBackground()
        }
    }
    
    // forPasteboardType: UTType.plainText.identifier = copy the text as plain text and not as link or somsthing
    // .renderingMode(.template) =  if not including this row the foregroundColor don't works

    struct TranslatedTextField: View {
        let fromText:String
        let toText:String
        let fromLanguage:UiLanguage
        let toLanguage:UiLanguage
        let onTranslateEvent:(TranslateEvent) -> Void
        
        private let tts = TextToSpeach()
        
        var body: some View{
            VStack(alignment: .leading){
                LanguageDisplay(language: fromLanguage)
                Text(fromText)
                    .foregroundColor(.onSurface)
                HStack{
                    Spacer()
                    Button(
                        action: {
                            UIPasteboard.general.setValue(
                                fromText,
                                forPasteboardType: UTType.plainText.identifier
                            )
                        }
                    ){
                        Image(uiImage: UIImage(named: "copy")!)
                            .renderingMode(.template)
                            .foregroundColor(.lightBlue)
                    }
                    Button(
                        action: {
                            onTranslateEvent(TranslateEvent.CloseTranslation())
                        }
                    ){
                        Image(systemName: "xmark")
                            .foregroundColor(.lightBlue)
                    }
                }
                Divider().padding()
                LanguageDisplay(language: toLanguage)
                    .padding(.bottom)
                Text(toText)
                    .foregroundColor(.onSurface)
                HStack{
                    Spacer()
                    Button(
                        action: {
                            UIPasteboard.general.setValue(
                                toText,
                                forPasteboardType: UTType.plainText.identifier
                            )
                        }
                    ){
                        Image(uiImage: UIImage(named: "copy")!)
                            .renderingMode(.template)
                            .foregroundColor(.lightBlue)
                    }
                    Button(
                        action: {
                            tts.speack(
                                text: toText,
                                language: toLanguage.language.langCode
                            )
                        }
                    ){
                        Image(systemName: "speaker.wave.2")
                            .foregroundColor(.lightBlue)
                    }
                }
            }
        }
    }
}
