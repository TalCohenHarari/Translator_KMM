package com.thc.translator_kmm.android.core.utils

import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.TextUnit

@Composable
fun Dp.textDp(): TextUnit = with(LocalDensity.current) {
    this@textDp.toSp()
}
