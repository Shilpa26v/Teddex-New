package com.tedeex.mshop.permission

internal fun interface ErrorCallback {
    fun onError(errorCode: String?, errorDescription: String?)
}