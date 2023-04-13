package com.thc.translator_kmm.voice_to_text.presentation

import com.thc.translator_kmm.core.domain.util.toCommonStateFlow
import com.thc.translator_kmm.voice_to_text.domain.VoiceToTextParser
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class VoiceToTextViewModel(
    private val parser: VoiceToTextParser,
    coroutineScope: CoroutineScope? = null
) {
    private val viewModelScope = coroutineScope ?: CoroutineScope(Dispatchers.Main)

    private val _state = MutableStateFlow(VoiceToTextState())
    val state = _state.combine(parser.state) { state, voiceParser ->
        state.copy(
            spokenText = voiceParser.result,
            recordError = voiceParser.error,
            displayState = when {
                voiceParser.error != null -> DisplayState.ERROR
                voiceParser.result.isNotBlank() && voiceParser.isSpeaking.not() -> {
                    DisplayState.DISPLAY_RESULTS
                }
                voiceParser.isSpeaking -> DisplayState.SPEAKING
                else -> DisplayState.WAITING_TO_TALK
            }
        )
    }
        .stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), VoiceToTextState())
        .toCommonStateFlow()

    init {
        viewModelScope.launch {
            while (true) {
                if (state.value.displayState == DisplayState.SPEAKING) {
                    _state.update {
                        it.copy(powerRatios = it.powerRatios + parser.state.value.powerRatio)
                    }
                    delay(50)
                }
            }
        }
    }


    fun onEvent(event: VoiceToTextEvent) {
        when (event) {
            is VoiceToTextEvent.PermissionResult -> {
                _state.update { it.copy(canRecord = event.isGranted) }
            }
            VoiceToTextEvent.Reset -> {
                parser.reset()
                _state.update { VoiceToTextState() }
            }
            is VoiceToTextEvent.ToggleRecording -> toggleRecording(event.languageCode)
            else -> Unit
        }
    }

    private fun toggleRecording(languageCode: String) {
        parser.cancel()
        if (state.value.displayState == DisplayState.SPEAKING) {
            parser.stopListening()
        } else {
            parser.startListening(languageCode)
        }
    }
}