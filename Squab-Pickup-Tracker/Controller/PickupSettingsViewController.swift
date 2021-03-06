//
//  PickupSettingsViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/18/20.
//

import UIKit
import CoreData

protocol PickupSettingsViewControllerDelegate {
    func didPressExit()
    
}


class PickupSettingsViewController: UIViewController {

    var delegate: PickupSettingsViewControllerDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var pigeonManager = PigeonDataManager()
    
    var currentSession: Session? {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pigeonManager.delegate = self
        
        view.layer.cornerRadius = 20

    }
    

  
    @IBAction func submitPressed(_ sender: UIButton) {
        
        if currentSession?.wasSubmitted == true {
            
            let alert = UIAlertController(title: "Session has already been submitted", message: "", preferredStyle: .alert)
            
            let submit = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                
            }
            
            
            alert.addAction(submit)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            
        
            let alert = UIAlertController(title: "Do you want to Submit this Session?", message: "", preferredStyle: .alert)
            
            let submit = UIAlertAction(title: "Yes", style: .default) { (action) in
                DispatchQueue.main.async {
                    self.pigeonManager.encodeCurrentSession(with: self.currentSession!)
                    
                }
            }
            
            let cancel = UIAlertAction(title: "No", style: .destructive) { (action) in
                
            }
            
            alert.addAction(cancel)
            alert.addAction(submit)
            
            self.present(alert, animated: true, completion: nil)
 
        }
        
    }
    
    
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.didPressExit()
        }
       
    }
    
    //MARK: - Data manipulation methods

    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context")
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
            
            
            // update session submission
            self.currentSession?.wasSubmitted = true
            self.saveData()
            
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


