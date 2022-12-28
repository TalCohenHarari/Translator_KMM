package com.thc.translator_kmm.translate.domain.translate.history

import com.thc.translator_kmm.core.domain.util.CommonFlow

interface HistoryDataSource {
    fun getHistory(): CommonFlow<List<HistoryItem>>
    suspend fun insertHistoryItem(item: HistoryItem)
}