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
    
    let settingsArray = [["Use Live Server", "Pickup Notifications", "Feed Notifications"],["Pickup Pen Order", "Feed Pen Order"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.backgroundColor = .none
        
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
    

    
}

//MARK: - UI Table View Delegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
}
