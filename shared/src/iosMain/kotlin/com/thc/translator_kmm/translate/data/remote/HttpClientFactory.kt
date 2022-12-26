package com.thc.translator_kmm.translate.data.remote

import io.ktor.client.*
import io.ktor.client.engine.darwin.*
import io.ktor.client.plugins.contentnegotiation.*
import io.ktor.serialization.kotlinx.json.*

actual class HttpClientFactory {
    actual fun create(): HttpClient {
        // "Darwin" - for IOS version
        return HttpClient(Darwin) {
            // With this install in KMM we get extra functionality, like plugins.
            // "ContentNegotiation" let us to parse in\out coming data to\from json.
            install(ContentNegotiation) {
                json()
            }
        }
    }
}