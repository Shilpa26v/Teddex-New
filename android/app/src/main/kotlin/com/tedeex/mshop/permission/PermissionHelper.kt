package com.tedeex.mshop.permission

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.tedeex.mshop.permission.PermissionConstants.PermissionGroup
import com.tedeex.mshop.permission.PermissionConstants.PermissionStatus
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

internal class PermissionHelper(private val activity: Activity) : MethodChannel.MethodCallHandler {
    private val serviceManager by lazy { ServiceManager() }
    private val appSettingsManager by lazy { AppSettingsManager() }
    var onActivityResult: ((requestCode: Int, permissions: Array<out String>, grantResults: IntArray) -> Boolean)? =
        null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkServiceStatus" -> {
                @PermissionConstants.PermissionGroup val permission = call.arguments.toString().toInt()
                serviceManager.checkServiceStatus(
                    permission,
                    activity,
                    { result.success(it) },
                    { errorCode, errorDescription -> result.error(errorCode.toString(), errorDescription, null) }
                )
            }
            "checkPermissionStatus" -> {
                @PermissionConstants.PermissionGroup val permission = call.arguments.toString().toInt()
                checkPermissionStatus(permission) { result.success(it) }
            }
            "requestPermissions" -> {
                val permissions = call.arguments<List<Int>>()
                if(permissions!=null) {
                    requestPermissions(
                        permissions,
                        { result.success(it) },
                        { errorCode, errorDescription -> result.error(errorCode.toString(), errorDescription, null) }
                    )
                }
            }
            "shouldShowRequestPermissionRationale" -> {
                @PermissionConstants.PermissionGroup val permission =
                    call.arguments.toString().toInt()

                shouldShowRequestPermissionRationale(
                    permission,
                    { result.success(it) },
                    { errorCode, errorDescription -> result.error(errorCode.toString(), errorDescription, null) }
                )
            }
            "openAppSettings" -> appSettingsManager.openAppSettings(
                activity,
                { result.success(it) },
                { errorCode, errorDescription -> result.error(errorCode.toString(), errorDescription, null) }
            )
            else -> result.notImplemented()
        }
    }

    internal fun interface RequestPermissionsSuccessCallback {
        fun onSuccess(results: Map<Int, Int>?)
    }

    internal fun interface CheckPermissionsSuccessCallback {
        fun onSuccess(@PermissionStatus permissionStatus: Int)
    }

    internal fun interface ShouldShowRequestPermissionRationaleSuccessCallback {
        fun onSuccess(shouldShowRequestPermissionRationale: Boolean)
    }

    private var ongoing = false

    private fun checkPermissionStatus(
        @PermissionGroup permission: Int,
        successCallback: CheckPermissionsSuccessCallback,
    ) {
        successCallback.onSuccess(
            determinePermissionStatus(
                permission,
                activity
            )
        )
    }

    private fun requestPermissions(
        permissions: List<Int>,
        successCallback: RequestPermissionsSuccessCallback,
        errorCallback: ErrorCallback
    ) {
        if (ongoing) {
            errorCallback.onError(
                "PermissionHandler.PermissionManager",
                "A request for permissions is already running, please wait for it to finish before doing another request (note that you can request multiple permissions at the same time)."
            )
            return
        }

        val requestResults: MutableMap<Int, Int> = HashMap()
        val permissionsToRequest = ArrayList<String>()
        for (permission in permissions) {
            @PermissionStatus val permissionStatus = determinePermissionStatus(permission, activity)
            if (permissionStatus == PermissionConstants.PERMISSION_STATUS_GRANTED) {
                if (!requestResults.containsKey(permission)) {
                    requestResults[permission] = PermissionConstants.PERMISSION_STATUS_GRANTED
                }
                continue
            }
            val names = PermissionUtils.getManifestNames(activity, permission)

            // check to see if we can find manifest names
            // if we can't add as unknown and continue
            if (names == null || names.isEmpty()) {
                if (!requestResults.containsKey(permission)) {
                    requestResults[permission] =
                        PermissionConstants.PERMISSION_STATUS_NOT_DETERMINED
                }
                continue
            }
            if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                val packageName = activity.packageName
                val intent = Intent()
                intent.action = Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                intent.data = Uri.parse("package:$packageName")
                activity.startActivityForResult(
                    intent,
                    PermissionConstants.PERMISSION_CODE_IGNORE_BATTERY_OPTIMIZATIONS
                )
            } else {
                permissionsToRequest.addAll(names)
            }
        }
        val requestPermissions = permissionsToRequest.toTypedArray()
        onActivityResult = { _, resultPermissions, grantResults ->
            for (i in resultPermissions.indices) {
                val permissionName = resultPermissions[i]
                @PermissionGroup val permission = PermissionUtils.parseManifestName(permissionName)
                if (permission == PermissionConstants.PERMISSION_GROUP_UNKNOWN) continue
                val result = grantResults[i]
                if (permission == PermissionConstants.PERMISSION_GROUP_MICROPHONE) {
                    if (!requestResults.containsKey(PermissionConstants.PERMISSION_GROUP_MICROPHONE)) {
                        requestResults[PermissionConstants.PERMISSION_GROUP_MICROPHONE] =
                            PermissionUtils.toPermissionStatus(activity, permissionName, result)
                    }
                    if (!requestResults.containsKey(PermissionConstants.PERMISSION_GROUP_SPEECH)) {
                        requestResults[PermissionConstants.PERMISSION_GROUP_SPEECH] =
                            PermissionUtils.toPermissionStatus(activity, permissionName, result)
                    }
                } else if (permission == PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS) {
                    @PermissionStatus val permissionStatus =
                        PermissionUtils.toPermissionStatus(activity, permissionName, result)
                    if (!requestResults.containsKey(PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS)) {
                        requestResults[PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS] =
                            permissionStatus
                    }
                } else if (permission == PermissionConstants.PERMISSION_GROUP_LOCATION) {
                    @PermissionStatus val permissionStatus =
                        PermissionUtils.toPermissionStatus(activity, permissionName, result)
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
                        if (!requestResults.containsKey(PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS)) {
                            requestResults[PermissionConstants.PERMISSION_GROUP_LOCATION_ALWAYS] =
                                permissionStatus
                        }
                    }
                    if (!requestResults.containsKey(PermissionConstants.PERMISSION_GROUP_LOCATION_WHEN_IN_USE)) {
                        requestResults[PermissionConstants.PERMISSION_GROUP_LOCATION_WHEN_IN_USE] =
                            permissionStatus
                    }
                    requestResults[permission] = permissionStatus
                } else if (!requestResults.containsKey(permission)) {
                    requestResults[permission] =
                        PermissionUtils.toPermissionStatus(activity, permissionName, result)
                }
                PermissionUtils.updatePermissionShouldShowStatus(activity, permission)
            }
            successCallback.onSuccess(requestResults)
            ongoing = false
            true
        }

        if (permissionsToRequest.isNotEmpty()) {
            ongoing = true
            ActivityCompat.requestPermissions(
                activity,
                requestPermissions,
                PermissionConstants.PERMISSION_CODE
            )
        } else {
            ongoing = false
            if (requestResults.isNotEmpty()) {
                successCallback.onSuccess(requestResults)
            }
        }
    }

    @PermissionStatus
    private fun determinePermissionStatus(
        @PermissionGroup permission: Int,
        activity: Activity
    ): Int {
        if (permission == PermissionConstants.PERMISSION_GROUP_NOTIFICATION) {
            return checkNotificationPermissionStatus(activity)
        }
        val names = PermissionUtils.getManifestNames(activity, permission)
        if (names == null) {
            Log.d(
                PermissionConstants.LOG_TAG,
                "No android specific permissions needed for: $permission"
            )
            return PermissionConstants.PERMISSION_STATUS_GRANTED
        }

        //if no permissions were found then there is an issue and permission is not set in Android manifest
        if (names.isEmpty()) {
            Log.d(PermissionConstants.LOG_TAG, "No permissions found in manifest for: $permission")
            return PermissionConstants.PERMISSION_STATUS_NOT_DETERMINED
        }
        val targetsMOrHigher = activity.applicationInfo.targetSdkVersion >= Build.VERSION_CODES.M
        for (name in names) {
            // Only handle them if the client app actually targets a API level greater than M.
            if (targetsMOrHigher) {
                if (permission == PermissionConstants.PERMISSION_GROUP_IGNORE_BATTERY_OPTIMIZATIONS) {
                    val packageName = activity.packageName
                    val pm = activity.getSystemService(Context.POWER_SERVICE) as PowerManager
                    // PowerManager.isIgnoringBatteryOptimizations has been included in Android M first.
                    return if (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            pm.isIgnoringBatteryOptimizations(packageName)
                        } else {
                            true
                        }
                    ) {
                        PermissionConstants.PERMISSION_STATUS_GRANTED
                    } else {
                        PermissionConstants.PERMISSION_STATUS_DENIED
                    }
                }
                val permissionStatus = ContextCompat.checkSelfPermission(activity, name)
                if (permissionStatus == PackageManager.PERMISSION_DENIED) {
                    return if (!PermissionUtils.getRequestedPermissionBefore(activity, name)) {
                        PermissionConstants.PERMISSION_STATUS_NOT_DETERMINED
                    } else if (PermissionUtils.isNeverAskAgainSelected(activity, name)) {
                        PermissionConstants.PERMISSION_STATUS_NEVER_ASK_AGAIN
                    } else {
                        PermissionConstants.PERMISSION_STATUS_DENIED
                    }
                } else if (permissionStatus != PackageManager.PERMISSION_GRANTED) {
                    return PermissionConstants.PERMISSION_STATUS_DENIED
                }
            }
        }
        return PermissionConstants.PERMISSION_STATUS_GRANTED
    }

    private fun shouldShowRequestPermissionRationale(
        permission: Int,

        successCallback: ShouldShowRequestPermissionRationaleSuccessCallback,
        errorCallback: ErrorCallback
    ) {
        if (activity == null) {
            Log.d(PermissionConstants.LOG_TAG, "Unable to detect current Activity.")
            errorCallback.onError(
                "PermissionHandler.PermissionManager",
                "Unable to detect current Android Activity."
            )
            return
        }
        val names = PermissionUtils.getManifestNames(activity, permission)

        // if isn't an android specific group then go ahead and return false;
        if (names == null) {
            Log.d(
                PermissionConstants.LOG_TAG,
                "No android specific permissions needed for: $permission"
            )
            successCallback.onSuccess(false)
            return
        }
        if (names.isEmpty()) {
            Log.d(
                PermissionConstants.LOG_TAG,
                "No permissions found in manifest for: $permission no need to show request rationale"
            )
            successCallback.onSuccess(false)
            return
        }
        successCallback.onSuccess(
            ActivityCompat.shouldShowRequestPermissionRationale(
                activity,
                names[0]
            )
        )
    }

    private fun checkNotificationPermissionStatus(context: Context): Int {
        val manager = NotificationManagerCompat.from(context)
        val isGranted = manager.areNotificationsEnabled()
        return if (isGranted) {
            PermissionConstants.PERMISSION_STATUS_GRANTED
        } else PermissionConstants.PERMISSION_STATUS_DENIED
    }


}