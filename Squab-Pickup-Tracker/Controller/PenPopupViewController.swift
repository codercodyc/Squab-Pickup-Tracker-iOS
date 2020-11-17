//
//  PenPopupViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/9/20.
//

import UIKit
import CoreData

protocol PenPopupViewControllerDelegate {
    func didSelectPen(pen: String)
}



class PenPopupViewController: UIViewController {

    @IBOutlet weak var penListTableView: UITableView!
    @IBOutlet var popupView: UIView!
    
    var delegate: PenPopupViewControllerDelegate?
    
    var penData: [Pen]? {
        didSet {
            
        }
    }
    
    //var pigeonData = PigeonData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //preferredContentSize = CGSize(width: 250, height: 100)
        
        
        penListTableView.delegate = self
        penListTableView.dataSource = self
        penListTableView.backgroundColor = #colorLiteral(red: 0, green: 0.8078431373, blue: 0.7882352941, alpha: 1)
        //penListTableView.layer.cornerRadius = 15
        
        view.autoresizesSubviews = true
        penListTableView.autoresizesSubviews = true
        popupView.autoresizesSubviews = true
//        view.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
//        view.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
//       penListTableView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
//       penListTableView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth
//
        
        penListTableView.reloadData()
        
        let totalTableHeight = penData!.count * 50
        
        if totalTableHeight <= 12 * 50 {
            
            preferredContentSize = CGSize(width: 275, height: totalTableHeight)
        } else {
            preferredContentSize = CGSize(width: 275, height: 12 * 50)
            
        }
        
        //penListTableView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
        
        
        
    }
    

}

extension PenPopupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return penData!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentPen = penData![indexPath.row].id
        var cell = UITableViewCell()
        
        if let tempCell = penListTableView.dequeueReusableCell(withIdentifier: K.PenListCellIdentifier) as? PenListCell {
            tempCell.penLabel.text = currentPen
            cell = tempCell
        }
        return cell
    }
    
    
}

extension PenPopupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = penListTableView.cellForRow(at: indexPath) as? PenListCell {
            
            self.delegate?.didSelectPen(pen: cell.penLabel.text!)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}


extension PenPopupViewController: PickupPenViewControllerDelegate {
    func didSelectNest(nest: Nest) {
        
    }
    
    
}
