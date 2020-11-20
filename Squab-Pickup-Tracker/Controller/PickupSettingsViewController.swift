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
        
        pigeonManager.delegate = self

        // Do any additional setup after loading the view.
    }
    

  
    @IBAction func submitPressed(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.pigeonManager.encodeCurrentSession(with: self.currentSession!)
            
        }
            
            
        
        
        
    }
    
    
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.didPressExit()
        }
       
    }
    
}

//MARK: - PigeonDataManagerDelegate


extension PickupSettingsViewController: PigeonDataManagerDelegate {
    func didDownloadData(data: PigeonData?) {
        
    }
    
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            
            
            let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                
                
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    func didSubmitSession() {
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: "Session Submitted", message: "", preferredStyle: .alert)
            
            
            
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                self.delegate?.didPressExit()
                
            }
            
            
            
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}