//
//  StoragePermissionStrategy.swift
//  Runner
//
//  Created by iMac on 14/05/21.
//

import Foundation
class StoragePermissionStrategy :NSObject, PermissionStrategy {

    func checkPermissionStatus(permission:PermissionGroup) -> PermissionStatus {
        return StoragePermissionStrategy.permissionStatus()
    }

    func checkServiceStatus(permission:PermissionGroup) -> ServiceStatus {
        return ServiceStatus.NotApplicable
    }

    func requestPermission(permission:PermissionGroup, completionHandler:PermissionStatusHandler) {
        completionHandler(StoragePermissionStrategy.permissionStatus())
    }

    class func permissionStatus() -> PermissionStatus {
        return PermissionStatus.Granted
    }
}
