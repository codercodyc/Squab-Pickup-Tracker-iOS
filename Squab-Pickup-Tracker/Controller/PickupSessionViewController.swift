//
//  PickupSessionViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/14/20.
//

import UIKit

class PickupSessionViewController: UIViewController {
    
    @IBOutlet weak var pickupSessionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickupSessionButton.layer.cornerRadius = pickupSessionButton.frame.height / 2
        pickupSessionButton.layer.shadowColor = UIColor.black.cgColor
        pickupSessionButton.layer.shadowOpacity = 0.5
        pickupSessionButton.layer.shadowOffset = .init(width: 0, height: 4)
        pickupSessionButton.layer.shadowRadius = 10

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }

    @IBAction func pickupSessionPressed(_ sender: UIButton) {
        
        
    }
    

}
