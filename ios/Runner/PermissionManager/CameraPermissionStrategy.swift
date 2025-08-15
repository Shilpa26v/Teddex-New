import Foundation
import AVFoundation

class CameraPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission:PermissionGroup) -> PermissionStatus {
        return CameraPermissionStrategy.permissionStatus()
    }
    
    func checkServiceStatus(permission:PermissionGroup) -> ServiceStatus {
        return ServiceStatus.NotApplicable
    }
    
    func requestPermission(permission:PermissionGroup, completionHandler: @escaping PermissionStatusHandler) {
        let status = self.checkPermissionStatus(permission: permission)
        if(status != PermissionStatus.Denied) {
            completionHandler(status)
            return
        }
        AVCaptureDevice.requestAccess(for : AVMediaType.video) { granted in
            completionHandler(self.checkPermissionStatus(permission: permission))
        }
    }
    
    class func permissionStatus() -> PermissionStatus {
        let status:AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch (status) {
        case AVAuthorizationStatus.notDetermined:
            return PermissionStatus.Denied
        case AVAuthorizationStatus.restricted:
            return PermissionStatus.Restricted
        case AVAuthorizationStatus.denied:
            return PermissionStatus.Denied
        case AVAuthorizationStatus.authorized:
            return PermissionStatus.Granted
        @unknown default:
            return PermissionStatus.Denied
        }
    }
}
