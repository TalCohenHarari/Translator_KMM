package com.thc.translator_kmm.translate.data.local

import android.content.Context
import com.squareup.sqldelight.android.AndroidSqliteDriver
import com.squareup.sqldelight.db.SqlDriver
import com.thc.translator_kmm.database.TranslateDatabase

actual class DatabaseDriverFactory(
    private val context: Context
) {
    actual fun create(): SqlDriver {
        //TODO: Shared Constants object and put there the db name
        return AndroidSqliteDriver(TranslateDatabase.Schema, context, "translate.db")
    }
}