//
//  CullViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 12/2/20.
//

import UIKit

class CullViewController: UIViewController {

    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectionView.setShadow()
        selectionView.setRadius(with: 15)

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.title = "Cull Pairs"

    }
    

    
}

