//
//  PermissionHandlerEnums.swift
//  Runner
//
//  Created by iMac on 14/05/21.
//

import Foundation

enum PermissionGroup:Int {
    case Calendar = 0
    case Camera
    case Contacts
    case Location
    case LocationAlways
    case LocationWhenInUse
    case MediaLibrary
    case Microphone
    case Phone
    case Photos
    case PhotosAddOnly
    case Reminders
    case Sensors
    case Sms
    case Speech
    case Storage
    case IgnoreBatteryOptimizations
    case Notification
    case AccessMediaLocation
    case ActivityRecognition
    case Unknown
    case Bluetooth
    case ManageExternalStorage
    case SystemAlertWindow
}

enum PermissionStatus:Int {
    case Denied = 0
    case Granted = 1
    case Restricted = 2
    case Limited = 3
    case PermanentlyDenied = 4
}

enum ServiceStatus:Int {
    case Disabled = 0
    case Enabled
    case NotApplicable
}
