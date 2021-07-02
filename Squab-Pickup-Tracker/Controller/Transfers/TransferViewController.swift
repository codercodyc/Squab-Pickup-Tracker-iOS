//
//  TransferViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/29/21.
//

import UIKit
import CoreData

class TransferViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pairIdTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    private let transferDataManager = TransferDataManager()
    
    var transferType: String?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = transferType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.makeMainButton(fontSize: 25)
        
    }
    

    @IBAction func submitPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    

}
