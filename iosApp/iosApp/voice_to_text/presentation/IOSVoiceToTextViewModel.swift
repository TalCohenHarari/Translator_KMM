//
//  IOSVoiceToTextViewModel.swift
//  iosApp
//
//  Created by Tal cohen harari on 13/04/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import shared
import Combine

@MainActor class IOSVoiceToTextViewModel: ObservableObject {
    // any = Because VoiceToTextParser is interface so we should say we accept any type of implementation.
    private var parser: any VoiceToTextParser
    private let languageCode:String
    
    private let viewModel: VoiceToTextViewModel
    
    @Published var state = VoiceToTextState(
        powerRatios: [],
        spokenText: "",
        canRecord: false,
        recordError: nil,
        displayState: nil
    )
    //To cancel collect emissions from our shared viewModel
    private var handle: DisposableHandle?
    
    init(parser: any VoiceToTextParser, languageCode: String){
        self.parser = parser
        self.languageCode = languageCode
        self.viewModel = VoiceToTextViewModel(parser: parser,coroutineScope: nil)
    }
    
    func onEvent(event: VoiceToTextEvent){
        viewModel.onEvent(event: event)
    }
    
    func startObserving(){
        handle = viewModel.state.subscribe { [weak self] state in
            if let state {
                self?.state = state
            }
        }
    }
    
    func dispose() {
        //This will cancel the coroutine that run in the 'subscribe' block in startObserving function.
        handle?.dispose()
        onEvent(event: VoiceToTextEvent.Reset())
    }
