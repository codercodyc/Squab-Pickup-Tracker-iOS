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
       
        pickupButton.layer.cornerRadius = 10
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
   
    

}

