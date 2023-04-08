//
//  IOSTranslateViewModel.swift
//  iosApp
//
//  Created by Tal cohen harari on 06/04/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import shared

//Create the viewModel in this extension to limit the usage of this viewModel from this screen
// @MainActor = Make sure that the ui update operations inside this viewModel will only executed on the main thread
// ObservableObject = to define that the class can contain states
// @Published = is the observer pattern and on every change of this field the ui will update

extension TranslateScreen {
      @MainActor class IOSTranslateViewModel: ObservableObject {
          
        private var historyDataSource: HistoryDataSource
        private var translateUseCase: Translate
        
        private let viewModel: TranslateViewModel
        
          @Published var state: TranslateState = TranslateState(
            fromText: "",
            toText: nil,
            isTranslating: false,
            fromLanguage: UiLanguage(language: .english, imageName: "english"),
            toLanguage: UiLanguage(language: .german, imageName: "german"),
            isChoosingFromLanguage: false,
            isChoosingToLanguage: false,
            error: nil,
            history: []
          )
          
          private var handle: DisposableHandle?
          
        init(historyDataSource: HistoryDataSource,translateUseCase: Translate){
              self.historyDataSource = historyDataSource
              self.translateUseCase = translateUseCase
              self.viewModel = TranslateViewModel(
                translate: translateUseCase,
                historyDataSource: historyDataSource,
                coroutineScope: nil
              )
        }
          
          func onEvent(event:TranslateEvent){
              self.viewModel.onEvent(event: event)
          }
          
          func startObservong() {
              handle = viewModel.state.subscribe(onCollect: { state in
                  if let state = state {
                      self.state = state
                  }
              })
          }
          
          //Make sure our collection stops when the view disapear from the screen
          func dispose() {
              handle?.dispose()
          }
    }
}
