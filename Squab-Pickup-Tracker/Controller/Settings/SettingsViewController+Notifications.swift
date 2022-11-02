//
//  SettingsViewController+Notifications.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/31/22.
//

import UIKit
import UserNotifications

extension SettingsViewController {
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            print("Notification settings: \(settings)")
            
            
            if settings.authorizationStatus == .authorized {
                
                
            } else if settings.authorizationStatus == .denied {
                print("denied")
                
                
            }
        }
    }
    
    
}
