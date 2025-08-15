import UIKit
import Foundation
import Flutter

typealias PermissionRequestCompletion = ([AnyHashable : Any]?) -> Void


class PermissionManager {
    private var strategyInstances:NSMutableArray = NSMutableArray()
    
    static func checkPermissionStatus(permission:PermissionGroup, result:FlutterResult) {
        let permissionStrategy:PermissionStrategy! = PermissionManager.createPermissionStrategy(permission: permission)
        let status:PermissionStatus = permissionStrategy.checkPermissionStatus(permission: permission)
        result(Codec.encodePermissionStatus(permissionStatus: status))
    }
    
    static func checkServiceStatus(permission:PermissionGroup, result:FlutterResult) {
        let permissionStrategy:PermissionStrategy! = PermissionManager.createPermissionStrategy(permission: permission)
        let status:ServiceStatus = permissionStrategy.checkServiceStatus(permission: permission)
        result(Codec.encodeServiceStatus(serviceStatus: status))
    }
    
    func requestPermissions(permissions:[PermissionGroup], completion: @escaping PermissionRequestCompletion) {
        var permissionStatusResult = [AnyHashable : Any]()
        guard !permissions.isEmpty else {
            completion(permissionStatusResult)
            return
        }
        let requestQueue = NSMutableArray()
        
        permissions.forEach { permissionGroup in
            requestQueue.add(permissionGroup)
            let permissionStrategy = PermissionManager.createPermissionStrategy(permission: permissionGroup)
            strategyInstances.add(permissionStrategy as Any)
            permissionStrategy.requestPermission(permission: permissionGroup) { permissionStatus in
                permissionStatusResult[permissionGroup.rawValue] = Codec.encodePermissionStatus(permissionStatus: permissionStatus)
                requestQueue.remove(permissionGroup)
                self.strategyInstances.remove(permissionStrategy as Any)
                if requestQueue.count == 0 {
                    completion(permissionStatusResult)
                    return
                }
            }
        }
    }
    
    class func openAppSettings(result: @escaping FlutterResult) {
        UIApplication.shared.open(URL.init(string: UIApplication.openSettingsURLString)!, options: [:]) { success in
            result(NSNumber(value:success))
        }
    }
    
    class func createPermissionStrategy(permission:PermissionGroup) -> PermissionStrategy {
        switch (permission) {
//        case PermissionGroup.Calendar, PermissionGroup.Reminders:
//            return EventPermissionStrategy()
        case PermissionGroup.Camera:
            return CameraPermissionStrategy()
//        case PermissionGroup.Microphone:
//            return AudioVideoPermissionStrategy()
        case PermissionGroup.Contacts:
            return ContactPermissionStrategy()
        case PermissionGroup.Photos, PermissionGroup.PhotosAddOnly:
            return PhotoPermissionStrategy()
        case PermissionGroup.Notification:
            return NotificationPermissionStrategy()
        case PermissionGroup.Storage:
            return StoragePermissionStrategy()
//        case PermissionGroup.Location,
//            PermissionGroup.LocationAlways,
//            PermissionGroup.LocationWhenInUse:
//            return LocationPermissionStrategy()
        default:
            return UnknownPermissionStrategy()
        }
    }
}
