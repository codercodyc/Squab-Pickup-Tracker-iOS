//
//  DashboardViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/11/20.
//

import UIKit
import WebKit



class DashboardViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    
    
    var urlString = "https://dkcpigeons.tk/dashapp/"
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        title = "Dashboard"
        
        
        //Call dashboard website
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    
    
    
    
    

}



