//
//  SettingsToggleTableViewCell.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/27/22.
//

import UIKit

class SettingsToggleTableViewCell: UITableViewCell {

//MARK: - Parameters
    
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var switchStatus: UISwitch!
    
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
        switch settingsLabel.text {
        case "Use Live Server":
            if sender.isOn {
                UserDefaults.standard.setValue(true, forKey: K.liveServerStatusKey)
            } else {
                UserDefaults.standard.setValue(false, forKey: K.liveServerStatusKey)
            }
        case "Pickup Notifications":
            if sender.isOn {
                UserDefaults.standard.setValue(true, forKey: K.pickupNotificationsKey)
            } else {
                UserDefaults.standard.setValue(false, forKey: K.pickupNotificationsKey)
            }
        case "Feed Notifications":
            if sender.isOn {
                UserDefaults.standard.setValue(true, forKey: K.feedNotificationsKey)
            } else {
                UserDefaults.standard.setValue(false, forKey: K.feedNotificationsKey)
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
