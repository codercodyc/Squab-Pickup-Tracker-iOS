//
//  TransferViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/29/21.
//

import UIKit
import CoreData

class TransferViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var pairIdLabel: UILabel!
    @IBOutlet weak var pairIdTextField: UITextField!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var fromVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var toVerticalConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var transferTypeLabel: UILabel!
    
    private let transferDataManager = TransferDataManager()
    
    private var transferHistory = [PairLocationChange]()
    
    var transferType: String? {
        didSet {
            navigationItem.title = transferType! + " Pair"
           
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.makeMainButton(fontSize: 25)
        transferTypeLabel.text = transferType
        
        pairIdTextField.delegate = self
        toTextField.delegate = self
        fromTextField.delegate = self
        
        configureViews(transferType: transferType)
        
        pairIdTextField.formatField()
        fromTextField.formatField()
        toTextField.formatField()
        
        pairIdTextField.returnKeyType = .continue
        
    }
    

    @IBAction func submitPressed(_ sender: UIButton) {
//        navigationController?.popViewController(animated: true)
        
        
    }
    
    
    func configureViews(transferType: String?) {
        switch transferType {
        case "New":
            pairIdLabel.removeFromSuperview()
            pairIdTextField.removeFromSuperview()
            fromLabel.removeFromSuperview()
            fromTextField.removeFromSuperview()
            toVerticalConstraint.constant = 50
            return
        case "Cull":
            toLabel.removeFromSuperview()
            toTextField.removeFromSuperview()
            return
        default:
            return
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == pairIdTextField {
            guard let pairId = textField.text else {return}
            transferHistory = transferDataManager.loadPairHistory(pairId: pairId)
            
            fromTextField.text = transferDataManager.currentNest(pairHistory: transferHistory)
        
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let pairIdTextField = pairIdTextField else {return}
//
//        pairIdTextField.resignFirstResponder()
//        toTextField.resignFirstResponder()
//        fromTextField.resignFirstResponder()
    }
    

}

extension UITextField {
    
    func formatField() {
        layer.cornerRadius = 15
        layer.masksToBounds = false
        borderStyle = .none
        backgroundColor = .white
        layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
    }
    
    
}

