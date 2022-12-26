package com.thc.translator_kmm.translate.data.remote

import io.ktor.client.*

//expect = like abstract class but it is say that we need that class will have impl in all other packages like "androidMain" and "iosMain"
expect class HttpClientFactory {
    fun create(): HttpClient
}