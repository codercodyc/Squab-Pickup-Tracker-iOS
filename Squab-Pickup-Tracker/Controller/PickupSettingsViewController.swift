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
    
    var pigeonManager = PigeonDataManager()
    
    var currentSession: Session? {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  
    @IBAction func submitPressed(_ sender: UIButton) {
        	pigeonManager.encodeCurrentSession(with: currentSession!)
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.didPressExit()
        }
       
    }
    
}
