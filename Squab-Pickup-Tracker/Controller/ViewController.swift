//
//  ViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit

//protocol ViewControllerDelegate {
//    func loadURLRequest(urlRequest: URLRequest)
//}

class ViewController: UIViewController {
    
    @IBOutlet weak var pickupButton: UIButton!
    @IBOutlet weak var dashboardButton: UIButton!
    
//    var delegate: ViewControllerDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        				
        
        pickupButton.layer.cornerRadius = pickupButton.frame.height / 2
        pickupButton.layer.shadowColor = UIColor.black.cgColor
        pickupButton.layer.shadowOpacity = 0.5
        pickupButton.layer.shadowOffset = .init(width: 0, height: 4)
        pickupButton.layer.shadowRadius = 10
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    
   
   
  
    
    
}



