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

class TransferViewController: UIViewController, UITextFieldDelegate, TransferDataManagerDelegate {
    
    var delegate: TransferViewControllerDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var pairIdLabel: UILabel!
    @IBOutlet weak var pairIdTextField: UITextField!
    @IBOutlet weak var pairIdStatusImage: UIImageView!
    @IBOutlet weak var pairIdErrorLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var fromVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var fromStatusImage: UIImageView!
    @IBOutlet weak var fromErrorLabel: UILabel!
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var toVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var toStatusImage: UIImageView!
    @IBOutlet weak var toErrorLabel: UILabel!
    
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
//            submitButton.setTitle(transferType, for: .normal)
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitButton.makeMainButton(fontSize: 25)
        
        transferDataManager.delegate = self
        
        pairIdTextField.delegate = self
        toTextField.delegate = self
        fromTextField.delegate = self
        
        pairIdErrorLabel.text = nil
        fromErrorLabel.text = nil
        toErrorLabel.text = nil
        
        configureViews(transferType: transferType)
        
        pairIdTextField.formatField()
        fromTextField.formatField()
        toTextField.formatField()
        
        
    }
    
    
    @IBAction func submitPressed(_ sender: UIButton) {
        
        
        if transferType == "New" || transferType == "Move" {
            if !toValid {
//                showSubmitError()
                return
            }
        }
        if transferType == "Cull" || transferType == "Move" {
            if !pairIdValid || !fromValid {
//                showSubmitError()
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
            
            
            self.uploadingAlert()

//            self.delegate?.didFinishSubmitting()
//            self.navigationController?.popViewController(animated: true)
        }
        
        
        
    }
    
    func uploadingAlert() {
        
        let alert = UIAlertController(title: "Submitting ...", message: nil, preferredStyle: .alert)
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
                
        alert.view.addSubview(activityIndicator)
        alert.view.heightAnchor.constraint(equalToConstant: 95).isActive = true
                
        activityIndicator.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -20).isActive = true
                
        present(alert, animated: true)
        
//        self.didSubmitTransfers()
    }
    
    
    func configureViews(transferType: String?) {
        switch transferType {
        case "New":
            pairIdLabel.removeFromSuperview()
            pairIdTextField.removeFromSuperview()
            pairIdStatusImage.removeFromSuperview()
//            pairIdErrorLabel.removeFromSuperview()
            
            fromLabel.removeFromSuperview()
            fromTextField.removeFromSuperview()
            fromStatusImage.removeFromSuperview()
//            fromErrorLabel.removeFromSuperview()
            
            toVerticalConstraint.constant = 50
            return
        case "Cull":
            toLabel.removeFromSuperview()
            toTextField.removeFromSuperview()
            toStatusImage.removeFromSuperview()
//            toErrorLabel.removeFromSuperview()
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
            if let pairId = transferDataManager.isValidFilledNest(penNest: penNest) {
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
    
    func didFailWithError(error: Error) {
        print("error")
    }
    
    func didSubmitTransfers() {
        dismiss(animated: true) {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.didFinishSubmitting()
        }
    }
    
    func didDownloadTransfers() {
    }
    
    func displayTransferInputError(error: String?, inputField: InputFields) {
        DispatchQueue.main.async {
            switch inputField {
            case .pairId:
                return
            case .from:
                self.fromErrorLabel.text = error
                return
            case .to:
                self.toErrorLabel.text = error
                return
            }
        }
    }
    
    
//    func showSubmitError() {
//        let vc = UIViewController()
//        let label = UILabel()
//        label.text = "Enter Valid Infor to Submit"
//        label.sizeToFit()
//        vc.view.addSubview(label)
//        label.center = view.center
//        vc.preferredContentSize = label.frame.size
//
//    }
    

}




extension UITextField {
    
    func formatField() {
        layer.cornerRadius = 10
        layer.masksToBounds = false
        borderStyle = .none
        backgroundColor = .white
        layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
    }
    
    
}

