//
//  PhotoPermissionStrategy.swift
//  Runner
//
//  Created by iMac on 14/05/21.
//

import Foundation
import Photos


class PhotoPermissionStrategy : NSObject , PermissionStrategy{
    private var addOnlyAccessLevel: Bool = false
    
    func checkPermissionStatus(permission:PermissionGroup) -> PermissionStatus {
        return PhotoPermissionStrategy.permissionStatus(addOnlyAccessLevel: addOnlyAccessLevel)
    }
    
    func checkServiceStatus(permission:PermissionGroup) -> ServiceStatus {
        return ServiceStatus.NotApplicable
    }
    
    func requestPermission(permission:PermissionGroup, completionHandler: @escaping PermissionStatusHandler) {
        let status:PermissionStatus = self.checkPermissionStatus(permission: permission)
        if status != PermissionStatus.Denied {
            completionHandler(status)
            return
        }
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization { authorizationStatus in
                DispatchQueue.main.async {
                    let status = PhotoPermissionStrategy.determinePermissionStatus(authorizationStatus: authorizationStatus)
                    completionHandler(status)
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization{ authorizationStatus in
                completionHandler(PhotoPermissionStrategy.determinePermissionStatus(authorizationStatus: authorizationStatus))
            }
        }
    }
    
    class func permissionStatus(addOnlyAccessLevel:Bool) -> PermissionStatus {
        var status:PHAuthorizationStatus = PHAuthorizationStatus.notDetermined
        if #available(iOS 14, *) {
            let write = (addOnlyAccessLevel ? PHAccessLevel.addOnly : PHAccessLevel.readWrite)
            status = PHPhotoLibrary.authorizationStatus(for: write)
        } else {
            status = PHPhotoLibrary.authorizationStatus()
        }
        return PhotoPermissionStrategy.determinePermissionStatus(authorizationStatus: status)
    }
    
    class func determinePermissionStatus(authorizationStatus:PHAuthorizationStatus) -> PermissionStatus {
        switch (authorizationStatus) {
        case PHAuthorizationStatus.notDetermined:
            return PermissionStatus.Denied
        case PHAuthorizationStatus.restricted:
            return PermissionStatus.Restricted
        case PHAuthorizationStatus.denied:
            return PermissionStatus.PermanentlyDenied
        case PHAuthorizationStatus.authorized:
            return PermissionStatus.Granted
        case PHAuthorizationStatus.limited:
            return PermissionStatus.Limited
        default :
            return PermissionStatus.Denied
        }
    }
}
