package com.thc.translator_kmm.translate.presentation

import com.thc.translator_kmm.core.presentation.UiLanguage

data class UiHistoryItem(
    val id: Long,
    val fromText:String,
    val toText:String,
    val fromLanguage: UiLanguage,
    val toLanguage: UiLanguage
)
