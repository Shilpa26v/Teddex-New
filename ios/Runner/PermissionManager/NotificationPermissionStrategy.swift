//
//  NotificationPermissionStrategy.swift
//  Runner
//
//  Created by iMac on 14/05/21.
//

import Foundation
import UserNotifications
import UserNotificationsUI

class NotificationPermissionStrategy : NSObject, PermissionStrategy {

    func checkPermissionStatus(permission:PermissionGroup) -> PermissionStatus {
      return NotificationPermissionStrategy.permissionStatus()
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
        
        
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                let center:UNUserNotificationCenter! = UNUserNotificationCenter.current()
                var authorizationOptions:UNAuthorizationOptions = UNAuthorizationOptions(rawValue: 0)
                authorizationOptions.insert(UNAuthorizationOptions.sound)
                authorizationOptions.insert(UNAuthorizationOptions.alert)
                authorizationOptions.insert(UNAuthorizationOptions.badge)
                
                
                
                center.requestAuthorization(options: authorizationOptions, completionHandler: { granted, error in
                    if error != nil || !granted {
                        completionHandler(PermissionStatus.PermanentlyDenied)
                        return
                    }

                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                        completionHandler(PermissionStatus.Granted)
                    })
                })

            } else {
                var notificationTypes:UIUserNotificationType = UIUserNotificationType(rawValue: 0)
                notificationTypes.remove(UIUserNotificationType.sound)
                notificationTypes.remove(UIUserNotificationType.alert)
                notificationTypes.remove(UIUserNotificationType.badge)
                
              let settings:UIUserNotificationSettings! = UIUserNotificationSettings.init(types: notificationTypes, categories:nil)
                UIApplication.shared.registerUserNotificationSettings(settings)

                UIApplication.shared.registerForRemoteNotifications()
                completionHandler(PermissionStatus.Granted)
            }
          }
    }

    class func permissionStatus() -> PermissionStatus {
        
        
       
        
        var permissionStatus:PermissionStatus = PermissionStatus.Granted
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.global().async {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
               
                if settings.authorizationStatus == UNAuthorizationStatus.denied {
                    permissionStatus = PermissionStatus.PermanentlyDenied
                } else if settings.authorizationStatus == UNAuthorizationStatus.notDetermined {
                    permissionStatus = PermissionStatus.Denied
              }
                semaphore.signal()
            }
        }
        
        semaphore.wait()
      

      return permissionStatus
    }
}
