//
//  PenPopupViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/9/20.
//

import UIKit

protocol PenPopupViewControllerDelegate {
    func didSelectPen(pen: String)
}



class PenPopupViewController: UIViewController {

    @IBOutlet weak var penListTableView: UITableView!
    @IBOutlet weak var penTableViewHeight: NSLayoutConstraint!
    @IBOutlet var popupView: UIView!
    
    var delegate: PenPopupViewControllerDelegate?
    
    var pigeonData = PigeonData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        
        penListTableView.delegate = self
        penListTableView.dataSource = self
        penListTableView.backgroundColor = UIColor.clear
        penListTableView.layer.cornerRadius = 15
        
//        let blurEffect = UIBlurEffect(style: .regular)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.frame
//
//        self.view.insertSubview(blurEffectView, at: 0)
        
//        penListTableView.backgroundView = blurEffectView
//        penListTableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
        
        penListTableView.reloadData()
        if pigeonData.penNames.count <= 12 {
            
            penTableViewHeight.constant = CGFloat(50 * pigeonData.penNames.count)
        } else {
            penTableViewHeight.constant = CGFloat(12 * 50)
        }
        
    }
    


}

extension PenPopupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pigeonData.penNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentPen = pigeonData.penNames[indexPath.row]
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
    func passPigeonData(data: PigeonData) {
        pigeonData = data
    }
    
    
}
