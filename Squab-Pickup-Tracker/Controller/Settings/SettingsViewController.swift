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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let status = getServerStatus()
        useLiveServerSwitch.isOn = status
        
        liveServerView.layer.cornerRadius = 10
        
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
