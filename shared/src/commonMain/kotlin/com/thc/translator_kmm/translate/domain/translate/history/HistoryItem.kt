package com.thc.translator_kmm.translate.domain.translate.history

data class HistoryItem(
    val id: Long?,
    val fromLanguageCode:String,
    val fromText:String,
    val toLanguageCode:String,
    val toText:String,
)
