//
//  SettingsViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/7/21.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedPenSettingText: String?
    let notificationManager = NotificationManager()
    var lastDeviceSettings: [String: Bool] = NotificationManager().getDeviceSettings()
    
    var settingsArray = [["Use Live Server", "Pickup Notifications", "Feed Notifications"],["Pickup Pen Order", "Feed Pen Order"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.backgroundColor = .none
        
        notificationManager.delegate = self
        
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus != .authorized {
                    self.notificationManager.disableNotifications()
                        self.notificationManager.encodeUserInfo()
                }
            }
            
        if ProcessInfo.processInfo.environment["DEBUG"] == "true" {
                print(K.environments.development)
            self.settingsArray[0].append(K.environments.development)
            } else {
                print(K.environments.production)
                self.settingsArray[0].append(K.environments.production)

            }
        }
        
            
        DispatchQueue.main.async {
            self.notificationManager.getUserInfo()
        }
        lastDeviceSettings = notificationManager.getDeviceSettings()
//        print(lastDeviceSettings)
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    
//MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.penOrder {
            let destinationVC = segue.destination as! PenOrderViewController
            if let orderType = selectedPenSettingText {
                destinationVC.penOrderType = orderType
            }
        }
    }
        
    

   
}

//MARK: - UI Table View Data Source

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray[section].count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsArray.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Connection Settings"
        } else if section == 1 {
            return "Pen Order Settings"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            if let safeCell = tableView.dequeueReusableCell(withIdentifier: K.settingToggleCell, for: indexPath) as? SettingsToggleTableViewCell {
                safeCell.settingsLabel.text = settingsArray[indexPath.section][indexPath.row]
                safeCell.switchStatus.isOn = safeCell.getServerStatus()
                safeCell.delegate = self
                safeCell.notificationManager.delegate = self
                cell = safeCell
            }
        } else if indexPath.section == 1 {
            if let safeCell = tableView.dequeueReusableCell(withIdentifier: K.settingsCell, for: indexPath) as? SettingsTableViewCell {
                safeCell.settingsLabel.text = settingsArray[indexPath.section][indexPath.row]
                cell = safeCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.5
    }
    

    
}

//MARK: - UI Table View Delegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let cell = tableView.cellForRow(at: indexPath) as? SettingsToggleTableViewCell {
                if cell.settingsLabel.text == "Use Live Server" {
                    cell.isSelected = false
//                    print("yay")
                    DispatchQueue.main.async {
                        self.notificationManager.getUserInfo()
                    }
                    tableView.reloadData()
                }
            }
            
        }
        
        // only apply for section 2
        if indexPath.section == 1 {
            if let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell {
                selectedPenSettingText = cell.settingsLabel.text
                cell.isSelected = false
                performSegue(withIdentifier: K.segue.penOrder, sender: self)
            }
        }
    }

}




//MARK: SettingsToggleTableViewCellDelegate Methods

extension SettingsViewController: SettingsToggleTableViewCellDelegate {
    func displayAlert() {
        let alert = UIAlertController(title: "Notifications Disabled", message: "Notifications are disabled in your system settings, please enable if you want to receive notifications.", preferredStyle: .alert)
        let settings = UIAlertAction(title: "Go to Settings", style: .default) { UIAlertAction in
            // Navigate to settings?
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(settings)
        alert.addAction(cancel)
        present(alert, animated: true) {
            self.tableView.reloadData()
        }
    }
    
    func refreshSettings() {
        tableView.reloadData()
    }
    
    func didChangeServer() {
        DispatchQueue.main.async {
            self.notificationManager.getUserInfo()
        }
    }
    
    func updateLastDeviceSettings(settings: [String : Bool]) {
        lastDeviceSettings = settings
    }
}


extension SettingsViewController: NotificationManagerDelegate {
    func didSubmitUserInfo() {
        lastDeviceSettings = notificationManager.getDeviceSettings()
//        print("didsubmit last devicesettings \(lastDeviceSettings)")
        return
    }
    
    func didFailWithError(error: Error) {
        let alert = UIAlertController(title: "Error syncing notification settings", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
//        print(self.lastDeviceSettings)
        DispatchQueue.main.async {
            UserDefaults.standard.setValue(self.lastDeviceSettings[K.pickupNotificationsKey], forKey: K.pickupNotificationsKey)
            UserDefaults.standard.setValue(self.lastDeviceSettings[K.feedNotificationsKey], forKey: K.feedNotificationsKey)
            self.tableView.reloadData()
        }
        
        
    }
    
    func didGetUserInfo(info: UserInfo) {
//        print(info)
        let deviceSettings = notificationManager.getDeviceSettings()
        
        if deviceSettings[K.pickupNotificationsKey] != info.pickupNotificationsEnabled {
            UserDefaults.standard.setValue(info.pickupNotificationsEnabled, forKey: K.pickupNotificationsKey)
            settingDifferenceUpdated()
        }
        if deviceSettings[K.feedNotificationsKey] != info.feedNotificationsEnabled {
            UserDefaults.standard.setValue(info.feedNotificationsEnabled, forKey: K.feedNotificationsKey)
            settingDifferenceUpdated()
        }
//        print("didgetuserinfo")
        DispatchQueue.main.async {
            self.tableView.reloadData()            
        }
    }
    
    func settingDifferenceUpdated() {
        let alert = UIAlertController(title: "Updated Settings", message: "Your notification settings were out of date, and were updated from the database.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { UIAlertAction in
            // Navigate to settings?
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    
}
