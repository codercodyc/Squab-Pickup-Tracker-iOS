//
//  TransferViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/29/21.
//

import UIKit
import CoreData

protocol TransferViewControllerDelegate {
    func didFinishSubmitting()
}

class TransferViewController: UIViewController, UITextFieldDelegate {
    
    var delegate: TransferViewControllerDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var pairIdLabel: UILabel!
    @IBOutlet weak var pairIdTextField: UITextField!
    @IBOutlet weak var pairIdStatusImage: UIImageView!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var fromVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromStatusImage: UIImageView!
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var toVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var toStatusImage: UIImageView!
    
    @IBOutlet weak var submitButton: UIButton!
    
    private var pairIdValid: Bool = false {
        didSet {
            if pairIdValid {
                pairIdStatusImage.image = UIImage(systemName: "checkmark.circle")
                pairIdStatusImage.tintColor = UIColor(named: K.color.newPair)
            } else {
                pairIdStatusImage.image = UIImage(systemName: "exclamationmark.circle")
                pairIdStatusImage.tintColor = UIColor(named: K.color.cull)
            }
        }
    }
    
    private var fromValid: Bool = false {
        didSet {
            if fromValid {
                fromStatusImage.image = UIImage(systemName: "checkmark.circle")
                fromStatusImage.tintColor = UIColor(named: K.color.newPair)
            } else {
                fromStatusImage.image = UIImage(systemName: "exclamationmark.circle")
                fromStatusImage.tintColor = UIColor(named: K.color.cull)
            }
        }
    }
    
    private var toValid: Bool = false {
        didSet {
            if toValid {
                toStatusImage.image = UIImage(systemName: "checkmark.circle")
                toStatusImage.tintColor = UIColor(named: K.color.newPair)
            } else {
                toStatusImage.image = UIImage(systemName: "exclamationmark.circle")
                toStatusImage.tintColor = UIColor(named: K.color.cull)
            }
        }
    }
    
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
        
        
        if transferType == "New" || transferType == "Move" {
            if !toValid {
                return
            }
        }
        if transferType == "Cull" || transferType == "Move" {
            if !pairIdValid || !fromValid {
                return
            }
        }
        
        let previousDate = datePicker.date.addingTimeInterval(-86400) // seconds in a day
        guard let outDate = dateToDoubleWithoutTime(with: previousDate) else {return}
        guard let currentDate = dateToDoubleWithoutTime(with: datePicker.date) else {return}

        if transferType == "New" {
            // generate new pair id
            let newPairId = transferDataManager.getNewPairId()
            guard let toPenNest = toTextField.text else {return}
            
            let transfer = Transfer(pairId: newPairId, penNest: toPenNest, transferType: "New Pair", inOut: "In", eventDate: currentDate)
            transferDataManager.postTransfer(with: TransferData(pairLocationChanges: [transfer]))
        }
        
        if transferType == "Move" {
            
            guard let pairId = pairIdTextField.text else {return}
            guard let fromPenNest = fromTextField.text else {return}
            guard let toPenNest = toTextField.text else {return}

            let outTransfer = Transfer(pairId: pairId, penNest: fromPenNest, transferType: "Move_Out", inOut: "Out", eventDate: outDate)
            let inTransfer = Transfer(pairId: pairId, penNest: toPenNest, transferType: "Move_In", inOut: "In", eventDate: currentDate)
//            let transfersToPost = TransferData(pairLocationChanges: [outTransfer, inTransfer])
            
            transferDataManager.postTransfer(with: TransferData(pairLocationChanges: [outTransfer, inTransfer]))
        }
        
        if transferType == "Cull" {
            guard let pairId = pairIdTextField.text else {return}
            guard let fromPenNest = fromTextField.text else {return}

            let transfer = Transfer(pairId: pairId, penNest: fromPenNest, transferType: "Cull", inOut: "Out", eventDate: currentDate)
            transferDataManager.postTransfer(with: TransferData(pairLocationChanges: [transfer]))
        }

        DispatchQueue.main.async {
            self.delegate?.didFinishSubmitting()
            self.navigationController?.popViewController(animated: true)
        }
        
        
        
    }
    
    
    func configureViews(transferType: String?) {
        switch transferType {
        case "New":
            pairIdLabel.removeFromSuperview()
            pairIdTextField.removeFromSuperview()
            pairIdStatusImage.removeFromSuperview()
            
            fromLabel.removeFromSuperview()
            fromTextField.removeFromSuperview()
            fromStatusImage.removeFromSuperview()
            
            toVerticalConstraint.constant = 50
            return
        case "Cull":
            toLabel.removeFromSuperview()
            toTextField.removeFromSuperview()
            toStatusImage.removeFromSuperview()
            return
        default:
            return
        }
    }
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == pairIdTextField {
            guard let pairId = textField.text else {return}
            transferHistory = transferDataManager.loadPairHistory(pairId: pairId)
            if let penNest = transferDataManager.currentNest(pairHistory: transferHistory){
                fromTextField.text = penNest
                pairIdValid = true
                fromValid = true

                return
            } else {
                fromTextField.text = nil
                pairIdValid = false
                fromValid = false
                

            }
        } else if textField == fromTextField {
            guard let penNest = textField.text else {return}
            if let pairId = transferDataManager.pairIdForNest(penNest: penNest) {
                pairIdTextField.text = pairId
                pairIdValid = true
                fromValid = true
            } else {
                pairIdTextField.text = nil
                pairIdValid = false
                fromValid = false
            }
        }
        if textField == toTextField {
            guard let penNest = textField.text else {
                toValid = false
                return
            }
            if transferDataManager.isValidOpenNest(penNest: penNest) {
                toValid = true
            } else {
                toValid = false
            }
            
            
        }
    }
    
  
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if transferType == "New" || transferType == "Move" {
            toTextField.resignFirstResponder()
        }
        if transferType == "Cull" || transferType == "Move" {
            pairIdTextField.resignFirstResponder()
            fromTextField.resignFirstResponder()
        }
        
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

