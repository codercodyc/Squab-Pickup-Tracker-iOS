//
//  SettingsViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/7/21.
//

import UIKit

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
