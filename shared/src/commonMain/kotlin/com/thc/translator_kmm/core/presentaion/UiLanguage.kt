package com.thc.translator_kmm.core.presentaion

import com.thc.translator_kmm.core.domain.language.Language

expect class UiLanguage {
    val language: Language
    companion object {
        fun byCode(langCode: String): UiLanguage
        val allLanguages: List<UiLanguage>
    }
}