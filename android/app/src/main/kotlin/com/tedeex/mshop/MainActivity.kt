package com.tedeex.mshop

import android.content.Context
import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import com.tedeex.mshop.permission.PermissionHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.util.Base64
import android.util.Log

class MainActivity : FlutterActivity() {
    companion object {
        private const val permissionChannelName = "com.tedeex.mshop.permissions"
    }

    private lateinit var permissionHelper: PermissionHelper

    override fun onCreate(savedInstanceState: Bundle?) {
        WindowCompat.setDecorFitsSystemWindows(window, false)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            splashScreen.setOnExitAnimationListener { splashScreenView -> splashScreenView.remove() }
        }
        permissionHelper = PermissionHelper(this)
       // printHashKey(this@MainActivity)
        super.onCreate(savedInstanceState)
    }

//    fun printHashKey(pContext: Context) {
//        try {
//            Log.d("MainActivity","in printHashKey")
//            val info: PackageInfo = pContext.getPackageManager().getPackageInfo(pContext.getPackageName(), PackageManager.GET_SIGNATURES)
//            for (signature in info.signatures) {
//                val md = MessageDigest.getInstance("SHA")
//                md.update(signature.toByteArray())
//                val hashKey = String(Base64.encode(md.digest(), 0))
//                Log.d("MainActivity", "printHashKey() Hash Key: $hashKey")
//                Log.i("MainActivity", "printHashKey() Hash Key: $hashKey")
//            }
//        } catch (e: NoSuchAlgorithmException) {
//            Log.e("MainActivity", "printHashKey()", e)
//        } catch (e: Exception) {
//            Log.e("MainActivity", "printHashKey()", e)
//        }
//    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, permissionChannelName)
            .setMethodCallHandler(permissionHelper)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int, permissions: Array<out String>, grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        permissionHelper.onActivityResult?.invoke(requestCode, permissions, grantResults)
        permissionHelper.onActivityResult = null
    }
}
