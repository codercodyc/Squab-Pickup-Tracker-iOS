//
//  SettingsViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/7/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var useLiveServerSwitch: UISwitch!
    @IBOutlet weak var liveServerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
//    let toggleSettingsArray = ["Use Live Server"]
    let settingsArray = [["Use Live Server"],["Pickup Pen Order", "Feed Pen Order"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = getServerStatus()
        useLiveServerSwitch.isOn = status
        
        liveServerView.layer.cornerRadius = 10
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func useLiveServerChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setValue(true, forKey: K.liveServerStatusKey)
            print("Set True")
        } else {
            UserDefaults.standard.setValue(false, forKey: K.liveServerStatusKey)
            print("Set False")
        }
    }
    
    
    func getServerStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: K.liveServerStatusKey)
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
            return "Settings"
        } else if section == 1 {
            return "Pen Order Settings"
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
            if let safeCell = tableView.dequeueReusableCell(withIdentifier: K.settingToggleCell, for: indexPath) as? SettingsToggleTableViewCell {
                safeCell.settingsLabel.text = settingsArray[indexPath.section][indexPath.row]
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
    
}
