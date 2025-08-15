//
//  Codec.swift
//  Runner
//
//  Created by iMac on 14/05/21.
//

import Foundation
class Codec {
    class func decodePermissionGroupFrom(event: Int) -> PermissionGroup {
        return PermissionGroup.init(rawValue: event)!
    }

    class func decodePermissionGroupsFrom(event:[Int]!) -> NSMutableArray {
        let result:NSMutableArray! = NSMutableArray()
        for number in event {
            result.add(self.decodePermissionGroupFrom(event: number))
         }
        return result
    }

    class func encodePermissionStatus(permissionStatus:PermissionStatus) -> NSNumber? {
        return NSNumber(value:Int32(permissionStatus.rawValue))
    }

    class func encodeServiceStatus(serviceStatus:ServiceStatus) -> NSNumber? {
        return NSNumber(value:Int32(serviceStatus.rawValue))
    }
}
