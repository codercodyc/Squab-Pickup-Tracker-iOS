//
//  SettingsToggleTableViewCell.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/27/22.
//

import UIKit
import UserNotifications

protocol SettingsToggleTableViewCellDelegate {
    func displayAlert()
    func refreshSettings()
    func didChangeServer()
    func updateLastDeviceSettings(settings: [String: Bool])
}

class SettingsToggleTableViewCell: UITableViewCell {

//MARK: - Parameters
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var switchStatus: UISwitch!
    
    var delegate: SettingsToggleTableViewCellDelegate?
    
    var notificationManager = NotificationManager()
    
    
// MARK: - Lifecycyle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
//MARK: - Functions

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchChanged(_ sender: UISwitch) {
        
        self.delegate?.updateLastDeviceSettings(settings: self.notificationManager.getDeviceSettings())
        switch settingsLabel.text {
        case "Use Live Server":
            DispatchQueue.main.async {
//                self.notificationManager.getUserInfo()
            }
            if sender.isOn {
                UserDefaults.standard.setValue(true, forKey: K.liveServerStatusKey)
            } else {
                UserDefaults.standard.setValue(false, forKey: K.liveServerStatusKey)
            }
        case "Pickup Notifications":
            if sender.isOn {
                
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == .authorized {
                        UserDefaults.standard.setValue(true, forKey: K.pickupNotificationsKey)
                        self.notificationManager.encodeUserInfo()
                    } else {
                        UserDefaults.standard.setValue(false, forKey: K.pickupNotificationsKey)
                        self.notificationManager.encodeUserInfo()
                        DispatchQueue.main.async {
                            self.delegate?.displayAlert()
                        }
                    }
                }
            } else {
                UserDefaults.standard.setValue(false, forKey: K.pickupNotificationsKey)
                self.notificationManager.encodeUserInfo()
            }
        case "Feed Notifications":
            if sender.isOn {

                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus == .authorized {
                        UserDefaults.standard.setValue(true, forKey: K.feedNotificationsKey)
                        self.notificationManager.encodeUserInfo()
                    } else {
//                        UserDefaults.standard.setValue(false, forKey: K.feedNotificationsKey)
                        self.notificationManager.encodeUserInfo()
                        DispatchQueue.main.async {
                            self.delegate?.displayAlert()
                        }
                    }
                }
            } else {
                UserDefaults.standard.setValue(false, forKey: K.feedNotificationsKey)
                self.notificationManager.encodeUserInfo()
            }
        default:
            break
        }
    }
    
    
    func getServerStatus() -> Bool {
        switch settingsLabel.text {
        case "Use Live Server":
            return UserDefaults.standard.bool(forKey: K.liveServerStatusKey)
        case "Pickup Notifications":
            return UserDefaults.standard.bool(forKey: K.pickupNotificationsKey)
        case "Feed Notifications":
            return UserDefaults.standard.bool(forKey: K.feedNotificationsKey)
        default:
            return false
            
        }
        
    }
    

    
    
    
}

