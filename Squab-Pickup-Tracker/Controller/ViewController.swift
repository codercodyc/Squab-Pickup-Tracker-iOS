//
//  ViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pickupButton: UIButton!
    @IBOutlet weak var dashboardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        dashboardButton.layer.cornerRadius = dashboardButton.frame.height / 2
        dashboardButton.layer.shadowColor = UIColor.black.cgColor
        dashboardButton.layer.shadowOpacity = 0.5
        dashboardButton.layer.shadowOffset = .init(width: 0, height: 4)
        dashboardButton.layer.shadowRadius = 10
        
        pickupButton.layer.cornerRadius = pickupButton.frame.height / 2
        pickupButton.layer.shadowColor = UIColor.black.cgColor
        pickupButton.layer.shadowOpacity = 0.5
        pickupButton.layer.shadowOffset = .init(width: 0, height: 4)
        pickupButton.layer.shadowRadius = 10
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
   
    

}



