package com.thc.translator_kmm.android.voice_to_text.presentation.components

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.MaterialTheme
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.drawscope.clipRect
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.thc.translator_kmm.android.core.theme.TranslatorTheme
import com.thc.translator_kmm.android.translate.presentation.components.gradientSurface
import kotlinx.coroutines.delay
import kotlin.random.Random

@Composable
fun VoiceRecorderDisplay(
    powerRatios: List<Float>,
    modifier: Modifier = Modifier
) {

    val primary = MaterialTheme.colors.primary

    Box(modifier = modifier
        .shadow(
            elevation = 4.dp,
            shape = RoundedCornerShape(20.dp)
        )
        .clip(shape = RoundedCornerShape(20.dp))
        .gradientSurface()
        .padding(
            vertical = 8.dp,
            horizontal = 32.dp
        )
        //drawBehind create a 'CANVAS'
        .drawBehind {
            val powerRatioWidth = 3.dp.toPx()
            //size.width = the size of the canvas
            // 2 * powerRatioWidth = because we want space between each bar as the bar width
            val powerRatioCount = (size.width / (2 * powerRatioWidth)).toInt()

            // clipRect = Even if in the preview we see bounds for the canvas, it is still draw beyond this
            // bounds, and because this we fix it by this 'clipRect' to clip our content we draw
            // in the given values (left ,top ,right ,bottom)
            clipRect(
                left = 0f,
                top = 0f,
                right = size.width,
                bottom = size.height
            ) {
                // takeLast = Because the list values can be more then what the canvas can fit, we need to
                // take the last up to date powerRatioValues
                powerRatios
                    .takeLast(powerRatioCount)
                    // To move it from right to left
                    .reversed()
                    // To draw our rectangle for each ratio
                    .forEachIndexed { index, ratio ->
                        //Getting the top start 'y' of our ratio item
                        val yTopStart = center.y - (size.height / 2) * ratio
                        drawRoundRect(
                            color = primary,
                            topLeft = Offset(
                                x = size.width - (index * (2 * powerRatioWidth)),
                                y = yTopStart
                            ),
                            size = Size(
                                width = powerRatioWidth,
                                height = (center.y - yTopStart) * 2f
                            ),
                            cornerRadius = CornerRadius(100f)
                        )
                    }

            }
        }
    )
}

@Preview(showBackground = true)
@Composable
private fun VoiceRecorderDisplayPreview() {

    var powerRatios  by remember {
        mutableStateOf((0..100))
    }

    LaunchedEffect(
        key1 = powerRatios,
        block = {
            delay(200)
            powerRatios = (0..Random.nextInt(100,200))
        }
    )

    TranslatorTheme {
        VoiceRecorderDisplay(
            powerRatios = powerRatios.map {
//                val percent = it / 100f
                // The reason we multiply the percent by '2 * PI' is that In the radians
                // notation this makes us all period
//                sin(percent * 2 * PI).toFloat()
                Random.nextFloat()
            },
            modifier = Modifier
                .fillMaxWidth()
                .height(100.dp)
        )
    }
}