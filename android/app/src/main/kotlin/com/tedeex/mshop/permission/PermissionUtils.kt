package com.tedeex.mshop.permission

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import java.util.*

object PermissionUtils {
    @PermissionConstants.PermissionGroup
    fun parseManifestName(permission: String?): Int {
        return when (permission) {
            Manifest.permission.READ_CALENDAR, Manifest.permission.WRITE_CALENDAR -> PermissionConstants.PERMISSION_GROUP_CALENDAR
            Manifest.permission.CAMERA -> PermissionConstants.PERMISSION_GROUP_CAMERA
            Manifest.permission.READ_CONTACTS, Manifest.permission.WRITE_CONTACTS, Manifest.permission.GET_ACCOUNTS -> PermissionConstants.PERMISSION_GROUP_CONTACTS
            Manifest.permission.ACCESS_BACKGROUND_LOCATION -> PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS
            Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION -> PermissionConstants.PERMISSION_GROUP_LOCATION
            Manifest.permission.RECORD_AUDIO -> PermissionConstants.PERMISSION_GROUP_MICROPHONE
            Manifest.permission.READ_PHONE_STATE, Manifest.permission.READ_PHONE_NUMBERS, Manifest.permission.CALL_PHONE, Manifest.permission.READ_CALL_LOG, Manifest.permission.WRITE_CALL_LOG, Manifest.permission.ADD_VOICEMAIL, Manifest.permission.USE_SIP, Manifest.permission.BIND_CALL_REDIRECTION_SERVICE -> PermissionConstants.PERMISSION_GROUP_PHONE
            Manifest.permission.BODY_SENSORS -> PermissionConstants.PERMISSION_GROUP_SENSORS
            Manifest.permission.SEND_SMS, Manifest.permission.RECEIVE_SMS, Manifest.permission.READ_SMS, Manifest.permission.RECEIVE_WAP_PUSH, Manifest.permission.RECEIVE_MMS -> PermissionConstants.PERMISSION_GROUP_SMS
            Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE -> PermissionConstants.PERMISSION_GROUP_STORAGE
            Manifest.permission.ACCESS_MEDIA_LOCATION -> PermissionConstants.PERMISSION_GROUP_ACCESS_MEDIA_LOCATION
            Manifest.permission.ACTIVITY_RECOGNITION -> PermissionConstants.PERMISSION_GROUP_ACTIVITY_RECOGNITION
            else -> PermissionConstants.PERMISSION_GROUP_UNKNOWN
        }
    }

    fun getManifestNames(context: Context?, @PermissionConstants.PermissionGroup permission: Int): List<String>? {
        val permissionNames = ArrayList<String>()
        when (permission) {
            PermissionConstants.PERMISSION_GROUP_CALENDAR -> {
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_CALENDAR
                    )
                ) permissionNames.add(Manifest.permission.READ_CALENDAR)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.WRITE_CALENDAR
                    )
                ) permissionNames.add(Manifest.permission.WRITE_CALENDAR)
            }
            PermissionConstants.PERMISSION_GROUP_CAMERA -> if (hasPermissionInManifest(
                    context,
                    permissionNames,
                    Manifest.permission.CAMERA
                )
            ) permissionNames.add(Manifest.permission.CAMERA)
            PermissionConstants.PERMISSION_GROUP_CONTACTS -> {
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_CONTACTS
                    )
                ) permissionNames.add(Manifest.permission.READ_CONTACTS)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.WRITE_CONTACTS
                    )
                ) permissionNames.add(Manifest.permission.WRITE_CONTACTS)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.GET_ACCOUNTS
                    )
                ) permissionNames.add(Manifest.permission.GET_ACCOUNTS)
            }
            PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    if (hasPermissionInManifest(
                            context,
                            permissionNames,
                            Manifest.permission.ACCESS_BACKGROUND_LOCATION
                        )
                    ) permissionNames.add(Manifest.permission.ACCESS_BACKGROUND_LOCATION)
                }
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                    )
                ) permissionNames.add(Manifest.permission.ACCESS_COARSE_LOCATION)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    )
                ) permissionNames.add(Manifest.permission.ACCESS_FINE_LOCATION)
            }
            PermissionConstants.PERMISSION_GROUP_LOCATION_WHEN_IN_USE, PermissionConstants.PERMISSION_GROUP_LOCATION -> {
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ACCESS_COARSE_LOCATION
                    )
                ) permissionNames.add(Manifest.permission.ACCESS_COARSE_LOCATION)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ACCESS_FINE_LOCATION
                    )
                ) permissionNames.add(Manifest.permission.ACCESS_FINE_LOCATION)
            }
            PermissionConstants.PERMISSION_GROUP_SPEECH, PermissionConstants.PERMISSION_GROUP_MICROPHONE -> if (hasPermissionInManifest(
                    context,
                    permissionNames,
                    Manifest.permission.RECORD_AUDIO
                )
            ) permissionNames.add(Manifest.permission.RECORD_AUDIO)
            PermissionConstants.PERMISSION_GROUP_PHONE -> {
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_PHONE_STATE
                    )
                ) permissionNames.add(Manifest.permission.READ_PHONE_STATE)
                if (Build.VERSION.SDK_INT > Build.VERSION_CODES.Q && hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_PHONE_NUMBERS
                    )
                ) {
                    permissionNames.add(Manifest.permission.READ_PHONE_NUMBERS)
                }
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.CALL_PHONE
                    )
                ) permissionNames.add(Manifest.permission.CALL_PHONE)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_CALL_LOG
                    )
                ) permissionNames.add(Manifest.permission.READ_CALL_LOG)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.WRITE_CALL_LOG
                    )
                ) permissionNames.add(Manifest.permission.WRITE_CALL_LOG)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ADD_VOICEMAIL
                    )
                ) permissionNames.add(Manifest.permission.ADD_VOICEMAIL)
                if (hasPermissionInManifest(context, permissionNames, Manifest.permission.USE_SIP)) permissionNames.add(
                    Manifest.permission.USE_SIP
                )
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q && hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.BIND_CALL_REDIRECTION_SERVICE
                    )
                ) permissionNames.add(Manifest.permission.BIND_CALL_REDIRECTION_SERVICE)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.ANSWER_PHONE_CALLS
                    )
                ) permissionNames.add(Manifest.permission.ANSWER_PHONE_CALLS)
            }
            PermissionConstants.PERMISSION_GROUP_SENSORS -> if (hasPermissionInManifest(
                    context,
                    permissionNames,
                    Manifest.permission.BODY_SENSORS
                )
            ) {
                permissionNames.add(Manifest.permission.BODY_SENSORS)
            }
            PermissionConstants.PERMISSION_GROUP_SMS -> {
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.SEND_SMS
                    )
                ) permissionNames.add(Manifest.permission.SEND_SMS)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.RECEIVE_SMS
                    )
                ) permissionNames.add(Manifest.permission.RECEIVE_SMS)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_SMS
                    )
                ) permissionNames.add(Manifest.permission.READ_SMS)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.RECEIVE_WAP_PUSH
                    )
                ) permissionNames.add(Manifest.permission.RECEIVE_WAP_PUSH)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.RECEIVE_MMS
                    )
                ) permissionNames.add(Manifest.permission.RECEIVE_MMS)
            }
            PermissionConstants.PERMISSION_GROUP_STORAGE -> {
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.READ_EXTERNAL_STORAGE
                    )
                ) permissionNames.add(Manifest.permission.READ_EXTERNAL_STORAGE)
                if (hasPermissionInManifest(
                        context,
                        permissionNames,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE
                    )
                ) permissionNames.add(Manifest.permission.WRITE_EXTERNAL_STORAGE)
            }
            PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS -> if (hasPermissionInManifest(
                    context,
                    permissionNames,
                    Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                )
            ) permissionNames.add(Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)
            PermissionConstants.PERMISSION_GROUP_ACCESS_MEDIA_LOCATION -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q && hasPermissionInManifest(
                    context,
                    permissionNames,
                    Manifest.permission.ACCESS_MEDIA_LOCATION
                )
            ) permissionNames.add(Manifest.permission.ACCESS_MEDIA_LOCATION)
            PermissionConstants.PERMISSION_GROUP_ACTIVITY_RECOGNITION -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q && hasPermissionInManifest(
                    context,
                    permissionNames,
                    Manifest.permission.ACTIVITY_RECOGNITION
                )
            ) permissionNames.add(Manifest.permission.ACTIVITY_RECOGNITION)
            PermissionConstants.PERMISSION_GROUP_NOTIFICATION, PermissionConstants.PERMISSION_GROUP_MEDIA_LIBRARY, PermissionConstants.PERMISSION_GROUP_PHOTOS, PermissionConstants.PERMISSION_GROUP_REMINDERS, PermissionConstants.PERMISSION_GROUP_UNKNOWN -> return null
        }
        return permissionNames
    }

    private fun hasPermissionInManifest(
        context: Context?,
        confirmedPermissions: ArrayList<String>,
        permission: String
    ): Boolean {
        var permissions: ArrayList<String> = confirmedPermissions
        try {
            for (r in permissions) {
                if (r == permission) {
                    return true
                }
            }
            if (context == null) {
                Log.d(PermissionConstants.LOG_TAG, "Unable to detect current Activity or App Context.")
                return false
            }
            val info = context
                .packageManager
                .getPackageInfo(context.packageName, PackageManager.GET_PERMISSIONS)
            if (info == null) {
                Log.d(
                    PermissionConstants.LOG_TAG,
                    "Unable to get Package info, will not be able to determine permissions to request."
                )
                return false
            }
            permissions = arrayListOf(*(info.requestedPermissions ?: emptyArray()))
            for (r in permissions) {
                if (r == permission) {
                    return true
                }
            }
        } catch (ex: Exception) {
            Log.d(PermissionConstants.LOG_TAG, "Unable to check manifest for permission: ", ex)
        }
        return false
    }

    @PermissionConstants.PermissionStatus
    fun toPermissionStatus(activity: Activity?, permissionName: String?, grantResult: Int): Int {
        return if (grantResult == PackageManager.PERMISSION_DENIED) {
            if (isNeverAskAgainSelected(activity, permissionName)) PermissionConstants.PERMISSION_STATUS_NEVER_ASK_AGAIN
            else PermissionConstants.PERMISSION_STATUS_DENIED
        } else PermissionConstants.PERMISSION_STATUS_GRANTED
    }

    fun updatePermissionShouldShowStatus(activity: Activity?, @PermissionConstants.PermissionGroup permission: Int) {
        if (activity == null) {
            return
        }
        val names = getManifestNames(activity, permission)
        if (names.isNullOrEmpty()) return
        for (name in names) {
            setRequestedPermission(activity, name)
        }
    }

    fun isNeverAskAgainSelected(activity: Activity?, name: String?): Boolean {
        return if (activity == null) {
            false
        } else neverAskAgainSelected(activity, name)
    }

    private fun neverAskAgainSelected(activity: Activity, permission: String?): Boolean {
        val hasRequestedPermissionBefore = getRequestedPermissionBefore(activity, permission)
        val shouldShowRequestPermissionRationale =
            ActivityCompat.shouldShowRequestPermissionRationale(activity, permission!!)
        return hasRequestedPermissionBefore && !shouldShowRequestPermissionRationale
    }

    private fun setRequestedPermission(context: Context, permission: String?) {
        val genPrefs = context.getSharedPreferences("GENERIC_PREFERENCES", Context.MODE_PRIVATE)
        val editor = genPrefs.edit()
        editor.putBoolean(permission, true)
        editor.apply()
    }

    fun getRequestedPermissionBefore(context: Context, permission: String?): Boolean {
        val genPrefs = context.getSharedPreferences("GENERIC_PREFERENCES", Context.MODE_PRIVATE)
        return genPrefs.getBoolean(permission, false)
    }
}