package com.thc.translator_kmm.voice_to_text.domain


data class VoiceToTextParserState(
    val result: String = "",
    val error: String? = null,
    val powerRatio: Float = 0f, // value between 0-1
    val isSpeaking: Boolean = false
)
