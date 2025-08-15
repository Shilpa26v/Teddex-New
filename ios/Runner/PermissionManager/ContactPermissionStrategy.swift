import Foundation
import Contacts
import AddressBook

class ContactPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission:PermissionGroup) -> PermissionStatus {
        return ContactPermissionStrategy.permissionStatus()
    }
    
    func checkServiceStatus(permission:PermissionGroup) -> ServiceStatus {
        return ServiceStatus.NotApplicable
    }
    
    func requestPermission(permission:PermissionGroup, completionHandler:@escaping PermissionStatusHandler) {
        let status:PermissionStatus = self.checkPermissionStatus(permission: permission)
        if(status != PermissionStatus.Denied) {
            completionHandler(status)
            return
        }
        ContactPermissionStrategy.requestPermissions(completionHandler: completionHandler)
    }
    
    class func permissionStatus() -> PermissionStatus {
        let status:CNAuthorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch (status) {
        case CNAuthorizationStatus.notDetermined:
            return PermissionStatus.Denied
        case CNAuthorizationStatus.restricted:
            return PermissionStatus.Restricted
        case CNAuthorizationStatus.denied:
            return PermissionStatus.PermanentlyDenied
        case CNAuthorizationStatus.authorized:
            return PermissionStatus.Granted
        @unknown default:
            return PermissionStatus.Denied
        }
    }
    
    class func requestPermissions(completionHandler: @escaping PermissionStatusHandler) {
        let contactStore: CNContactStore = CNContactStore()
        contactStore.requestAccess(for: CNEntityType.contacts) { granted, _  in
            if granted {
                completionHandler(PermissionStatus.Granted)
            } else {
                completionHandler(PermissionStatus.PermanentlyDenied)
            }
        }
    }
}
