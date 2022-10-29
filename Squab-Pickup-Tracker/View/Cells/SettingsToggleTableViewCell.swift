//
//  SettingsToggleTableViewCell.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/27/22.
//

import UIKit

class SettingsToggleTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var switchStatus: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if settingsLabel.text == "Use Live Server" {
            let status = getServerStatus()
            switchStatus.isOn = status
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchChanged(_ sender: UISwitch) {
        if settingsLabel.text == "Use Live Server" {
            if sender.isOn {
                UserDefaults.standard.setValue(true, forKey: K.liveServerStatusKey)
//                print("Set True")
            } else {
                UserDefaults.standard.setValue(false, forKey: K.liveServerStatusKey)
//                print("Set False")
            }
        }
    }
    
    
    func getServerStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: K.liveServerStatusKey)
    }
    
    
}
