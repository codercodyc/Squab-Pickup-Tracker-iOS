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
    @IBOutlet weak var transfersButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var feedButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        dashboardButton.makeMainButton(fontSize: 30)
        pickupButton.makeMainButton(fontSize: 30)
        transfersButton.makeMainButton(fontSize: 30)
        settingsButton.makeMainButton(fontSize: 30)
        feedButton.makeMainButton(fontSize: 30)
        
        
        getCoreDataDBPath()
        
//        print(UIDevice.current.model)
//        print(UIDevice.current.identifierForVendor?.uuidString)

        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    
   
    func getCoreDataDBPath() {
            let path = FileManager
                .default
                .urls(for: .applicationSupportDirectory, in: .userDomainMask)
                .last?
                .absoluteString
                .replacingOccurrences(of: "file://", with: "")
                .removingPercentEncoding

//            print("Core Data DB Path :: \(path ?? "Not found")")
        }
  
    
    
}



