package com.thc.translator_kmm.translate.data

import com.thc.translator_kmm.core.domain.language.Language
import com.thc.translator_kmm.translate.data.translate.TranslateDto
import com.thc.translator_kmm.translate.data.translate.TranslatedDto
import com.thc.translator_kmm.translate.domain.translate.TranslateClient
import com.thc.translator_kmm.translate.domain.translate.TranslateError
import com.thc.translator_kmm.translate.domain.translate.TranslateException
import io.ktor.client.*
import io.ktor.client.call.*
import io.ktor.client.request.*
import io.ktor.http.*
import io.ktor.utils.io.errors.*

class KtorTranslateClient(
    private val httpClient: HttpClient
) : TranslateClient {

    val baseUrl = "https://translate.pl-coding.com"

    override suspend fun translate(
        fromLanguage: Language,
        fromText: String,
        toLanguage: Language
    ): String {
        val result = try {
            httpClient.post {
                url("$baseUrl/translate")
                contentType(ContentType.Application.Json)
                setBody(
                    TranslateDto(
                        textToTranslate = fromText,
                        sourceLanguageCode = fromLanguage.langCode,
                        targetLanguageCode = toLanguage.langCode
                    )
                )
            }
        } catch (e: IOException) {
            throw TranslateException(TranslateError.SERVICE_UNAVAILABLE)
        }

        when (result.status.value) {
            in 200..299 -> Unit
            500 -> throw TranslateException(TranslateError.SERVER_ERROR)
            in 400..499 -> throw TranslateException(TranslateError.CLIENT_ERROR)
            else -> throw TranslateException(TranslateError.UNKNOWN_ERROR)
        }

        return try {
            result.body<TranslatedDto>().translateText
        } catch (e: Exception) {
            throw TranslateException(TranslateError.SERVICE_UNAVAILABLE)
        }
    }
}