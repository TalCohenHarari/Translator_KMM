package com.thc.translator_kmm.di

import com.thc.translator_kmm.database.TranslateDatabase
import com.thc.translator_kmm.translate.data.KtorTranslateClient
import com.thc.translator_kmm.translate.data.history.SqlDelightHistoryDataSource
import com.thc.translator_kmm.translate.data.local.DatabaseDriverFactory
import com.thc.translator_kmm.translate.data.remote.HttpClientFactory
import com.thc.translator_kmm.translate.domain.history.HistoryDataSource
import com.thc.translator_kmm.translate.domain.translate.Translate
import com.thc.translator_kmm.translate.domain.translate.TranslateClient

class AppModule {

    val historyDataSource: HistoryDataSource by lazy {
        SqlDelightHistoryDataSource(
            TranslateDatabase(
                DatabaseDriverFactory().create()
            )
        )
    }

    private val translateClient: TranslateClient by lazy {
        KtorTranslateClient(
            HttpClientFactory().create()
        )
    }

    val translateUseCase: Translate by lazy {
        Translate(translateClient,historyDataSource)
    }
}