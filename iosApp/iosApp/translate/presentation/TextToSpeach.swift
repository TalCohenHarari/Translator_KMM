//
//  TextToSpeach.swift
//  iosApp
//
//  Created by Tal cohen harari on 08/04/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import AVFAudio

struct TextToSpeach{
    
    private let sythesizer = AVSpeechSynthesizer()
    
    func speack(text: String, language: String){
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language:language)
        utterance.volume = 1
        sythesizer.speak(utterance)
    }
}
