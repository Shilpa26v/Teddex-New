import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let permissionChannelName = "com.tedeex.mshop.permissions"

    var methodResult: FlutterResult? = nil

    override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


