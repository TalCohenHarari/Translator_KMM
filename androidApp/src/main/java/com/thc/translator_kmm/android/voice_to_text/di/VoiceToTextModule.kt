package com.thc.translator_kmm.android.voice_to_text.di

import com.thc.translator_kmm.TranslateApp
import com.thc.translator_kmm.android.voice_to_text.data.AndroidVoiceToTextParser
import com.thc.translator_kmm.voice_to_text.domain.VoiceToTextParser
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.components.ViewModelComponent
import dagger.hilt.android.scopes.ViewModelScoped

@Module
@InstallIn(ViewModelComponent::class)
object VoiceToTextModule {

    @Provides
    @ViewModelScoped
    fun provideVoiceToTextParser(app: TranslateApp): VoiceToTextParser =
        AndroidVoiceToTextParser(app)
}