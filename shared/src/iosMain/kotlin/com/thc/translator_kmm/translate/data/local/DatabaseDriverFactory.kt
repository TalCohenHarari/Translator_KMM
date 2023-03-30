package com.thc.translator_kmm.translate.data.local

import com.squareup.sqldelight.db.SqlDriver
import com.squareup.sqldelight.drivers.native.NativeSqliteDriver
import com.thc.translator_kmm.database.TranslateDatabase

actual class DatabaseDriverFactory {
    actual fun create(): SqlDriver {
        //TODO: Shared Constants object and put there the db name
        //NativeSqliteDriver good for desktop, etc.
        return NativeSqliteDriver(TranslateDatabase.Schema, "translate.db")
    }
}