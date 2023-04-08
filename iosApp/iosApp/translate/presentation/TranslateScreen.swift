//
//  TranslateScreen.swift
//  iosApp
//
//  Created by Tal cohen harari on 06/04/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI
import shared

// @ObservedObject = to let know that the view can observe on published fields in the viewModel
struct TranslateScreen: View {
    private var historyDatasouece: HistoryDataSource
    private var translateUseCase: Translate
    @ObservedObject var viewModel: IOSTranslateViewModel
    
    init(historyDatasouece: HistoryDataSource, translateUseCase: Translate){
        self.historyDatasouece = historyDatasouece
        self.translateUseCase = translateUseCase
        self.viewModel = IOSTranslateViewModel(
            historyDataSource: historyDatasouece,
            translateUseCase: translateUseCase
        )
    }
    
    var body: some View {
        ZStack {
            List {
                HStack(alignment: .center) {
                    LanguageDropDown(
                        language: viewModel.state.fromLanguage,
                        isOpen: viewModel.state.isChoosingFromLanguage,
                        selectLanguage:{ language in
                            viewModel.onEvent(event: TranslateEvent.ChooseFromLanguage(language: language))
                        }
                    )
                    Spacer()
                    SwapLanguageButton(onClick: {viewModel.onEvent(event: TranslateEvent.SwapLanguages())})
                    Spacer()
                    LanguageDropDown(
                        language: viewModel.state.toLanguage,
                        isOpen: viewModel.state.isChoosingToLanguage,
                        selectLanguage:{ language in
                            viewModel.onEvent(event: TranslateEvent.ChooseToLanguage(language: language))
                        }
                    )
                }
                .listRowSeparator(.hidden) //When adding more elements do not do default sepearators
                .listRowBackground(Color.background)
                TranslateTextField(
                    fromText: Binding(get: {viewModel.state.fromText}, set: {
                        //'$0' like 'it' in kotlin
                        viewModel.onEvent(event: TranslateEvent.ChangeTranslationText(text: $0))
                    }),
                    toText: viewModel.state.toText,
                    isTranslating: viewModel.state.isTranslating,
                    fromLanguage: viewModel.state.fromLanguage,
                    toLanguage: viewModel.state.toLanguage,
                    onTranslateEvent: {
                        viewModel.onEvent(event: $0)
                        
                    }
                ).listRowSeparator(.hidden)
                 .listRowBackground(Color.background)
                
                if !viewModel.state.history.isEmpty {
                    Text("History")
                        .font(.title)
                        .bold()
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .listRowSeparator(.hidden)
                         .listRowBackground(Color.background)
                }
                
                ForEach(viewModel.state.history, id: \.self.id){ item in
                    TranslateHistoryItem(
                        item: item,
                        onClick: { viewModel.onEvent(event: TranslateEvent.SelectHistoryItem(item: item)) }
                    )
                }.listRowSeparator(.hidden)
                .listRowBackground(Color.background)
         
                    Spacer().listRowSeparator(.hidden)
                        .listRowBackground(Color.background)
                    Spacer().listRowSeparator(.hidden)
                        .listRowBackground(Color.background)
                
                
            }
            .listStyle(.plain) // Remove item style to not have box around each list item
            .buttonStyle(.plain) // Each item in that list is not a button (not clickable)
            
            VStack {
                Spacer()
                NavigationLink(destination: Text("Voice-to-text screen")){
                    ZStack{
                        Circle()
                            .foregroundColor(.primaryColor)
                            .padding()
                        Image(uiImage: UIImage(named: "mic")!)
                            .foregroundColor(.onPrimary)
                    }
                    .frame(maxWidth: 100, maxHeight: 100)
                }
            }
        }
        .onAppear {
            viewModel.startObservong()
        }
        .onDisappear {
            viewModel.dispose()
        }
        .navigationBarHidden(true)
    }
}
