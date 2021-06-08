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
    @IBOutlet weak var moveCullButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        dashboardButton.makeMainButton()
        pickupButton.makeMainButton()
        // Temporary Code to remove cull button
        moveCullButton.removeFromSuperview()
        
//        moveCullButton.makeMainButton()
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    
   
   
  
    
    
}



