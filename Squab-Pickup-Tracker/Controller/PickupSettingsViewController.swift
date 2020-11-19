//
//  PickupSettingsViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/18/20.
//

import UIKit

protocol PickupSettingsViewControllerDelegate {
    func didPressExit()
    
}


class PickupSettingsViewController: UIViewController {

    var delegate: PickupSettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.didPressExit()
        }
       
    }
    
}
