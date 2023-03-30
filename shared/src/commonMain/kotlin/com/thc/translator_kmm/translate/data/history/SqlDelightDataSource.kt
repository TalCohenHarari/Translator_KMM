package com.thc.translator_kmm.translate.data.history

import com.squareup.sqldelight.runtime.coroutines.asFlow
import com.squareup.sqldelight.runtime.coroutines.mapToList
import com.thc.translator_kmm.core.domain.util.CommonFlow
import com.thc.translator_kmm.core.domain.util.toCommonFlow
import com.thc.translator_kmm.database.TranslateDatabase
import com.thc.translator_kmm.translate.domain.history.HistoryDataSource
import com.thc.translator_kmm.translate.domain.history.HistoryItem
import kotlinx.coroutines.flow.map
import kotlinx.datetime.Clock

class SqlDelightHistoryDataSource(
    val db: TranslateDatabase
) : HistoryDataSource {

    private val queries = db.translateQueries

    override fun getHistory(): CommonFlow<List<HistoryItem>> {
        return queries
            .getHistory()
            .asFlow()
            .mapToList()
            //Map List<HistoryEntity> to List<HistoryItem>
            .map { history ->
                //Map HistoryEntity to HistoryItem
                history.map { it.toHistoryItem() }
            }
            .toCommonFlow()
    }

    override suspend fun insertHistoryItem(item: HistoryItem) {
        queries.insertHistoryEntity(
            id = item.id,
            fromLanguageCode = item.fromLanguageCode,
            fromText = item.fromText,
            toLanguageCode = item.toLanguageCode,
            toText = item.toText,
            timestamp = Clock.System.now().toEpochMilliseconds()
        )
    }
}