//
//  UnknownPermissionStrategy.swift
//  Runner
//
//  Created by iMac on 14/05/21.
//

import Foundation
class UnknownPermissionStrategy: NSObject, PermissionStrategy{

    func checkPermissionStatus(permission:PermissionGroup) -> PermissionStatus {
        return PermissionStatus.Denied
    }

    func checkServiceStatus(permission:PermissionGroup) -> ServiceStatus {
        return ServiceStatus.Disabled
    }

    func requestPermission(permission:PermissionGroup, completionHandler:PermissionStatusHandler) {
        completionHandler(PermissionStatus.PermanentlyDenied)
    }
}
