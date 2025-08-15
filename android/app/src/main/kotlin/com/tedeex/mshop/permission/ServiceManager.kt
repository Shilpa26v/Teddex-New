package com.tedeex.mshop.permission

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.location.LocationManager
import android.net.Uri
import android.os.Build
import android.telephony.TelephonyManager
import android.util.Log

internal class ServiceManager {
    internal fun interface SuccessCallback {
        fun onSuccess(@PermissionConstants.ServiceStatus serviceStatus: Int)
    }

    fun checkServiceStatus(
        permission: Int,
        context: Context?,
        successCallback: SuccessCallback,
        errorCallback: ErrorCallback
    ) {
        if (context == null) {
            Log.d(PermissionConstants.LOG_TAG, "Context cannot be null.")
            errorCallback.onError(
                "PermissionHandler.ServiceManager",
                "Android context cannot be null."
            )
            return
        }
        if (permission == PermissionConstants.PERMISSION_GROUP_LOCATION || permission == PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS || permission == PermissionConstants.PERMISSION_GROUP_LOCATION_WHEN_IN_USE) {
            val serviceStatus =
                if (isLocationServiceEnabled(context)) PermissionConstants.SERVICE_STATUS_ENABLED else PermissionConstants.SERVICE_STATUS_DISABLED
            successCallback.onSuccess(serviceStatus)
            return
        }
        if (permission == PermissionConstants.PERMISSION_GROUP_PHONE) {
            val pm = context.packageManager
            if (!pm.hasSystemFeature(PackageManager.FEATURE_TELEPHONY)) {
                successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE)
                return
            }
            val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
            if (telephonyManager.phoneType == TelephonyManager.PHONE_TYPE_NONE) {
                successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE)
                return
            }
            val callIntent = Intent(Intent.ACTION_CALL)
            callIntent.data = Uri.parse("tel:123123")
            val callAppsList = pm.queryIntentActivities(callIntent, 0)
            if (callAppsList.isEmpty()) {
                successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE)
                return
            }
            if (telephonyManager.simState != TelephonyManager.SIM_STATE_READY) {
                successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_DISABLED)
                return
            }
            successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_ENABLED)
            return
        }
        if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
            val serviceStatus =
                PermissionConstants.SERVICE_STATUS_ENABLED
            successCallback.onSuccess(serviceStatus)
            return
        }
        successCallback.onSuccess(PermissionConstants.SERVICE_STATUS_NOT_APPLICABLE)
    }

    private fun isLocationServiceEnabled(context: Context): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val locationManager = context.getSystemService(LocationManager::class.java)
                ?: return false
            locationManager.isLocationEnabled
        } else {
            val locationManager = context.getSystemService(LocationManager::class.java)
                ?: return false
            locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) || locationManager.isProviderEnabled(
                LocationManager.NETWORK_PROVIDER
            )
        }
    }
}