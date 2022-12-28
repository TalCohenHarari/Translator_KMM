package com.thc.translator_kmm.core.domain.util

fun interface DisposableHandle : kotlinx.coroutines.DisposableHandle
// This fun interface is the equivalent of below code:
/*
interface DisposableHandle: kotlinx.coroutines.DisposableHandle
fun DisposableHandle(block:()->Unit): DisposableHandle {
    return DisposableHandle { block()}
}
*/
