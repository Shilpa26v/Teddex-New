//
//  PermissionStrategy.swift
//  Runner
//
//  Created by iMac on 14/05/21.
//

import Foundation

typealias PermissionStatusHandler = (PermissionStatus)->Void

protocol PermissionStrategy : NSObject {
    func checkPermissionStatus(permission:PermissionGroup) -> PermissionStatus

    func checkServiceStatus(permission:PermissionGroup) -> ServiceStatus

    func requestPermission(permission:PermissionGroup, completionHandler: @escaping PermissionStatusHandler)
}
