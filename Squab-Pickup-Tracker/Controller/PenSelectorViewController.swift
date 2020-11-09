//
//  PenSelectorViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/8/20.
//

import UIKit

protocol PenSelectorViewControllerDelegate {
    func didSelectPen(sender: PenSelectorViewController, pen: String)
}



class PenSelectorViewController: UIViewController {
    
    var pigeonData = PigeonData()
    
    var delegate: PenSelectorViewControllerDelegate?
    
    @IBOutlet weak var penTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        penTableView.delegate = self
        penTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    


}


extension PenSelectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pigeonData.pen.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pensArray = Array(pigeonData.pen.keys).sorted()
        let currentPen = pensArray[indexPath.row]
        
        var cell = UITableViewCell()
        if let tempCell = penTableView.dequeueReusableCell(withIdentifier: K.tableCellIdentifier, for: indexPath) as? PenCell {
            tempCell.penLabel.text = currentPen
            cell = tempCell
        }
        return cell
    }
    
    
}

extension PenSelectorViewController: PickupPenViewControllerDelegate {
    func didGoToChangePenPage(data: PigeonData) {
        pigeonData = data
    }
    
    
}
    

extension PenSelectorViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let cell = penTableView.cellForRow(at: indexPath) as? PenCell {
            if let penNumber = cell.penLabel.text {
                self.delegate?.didSelectPen(sender: self, pen: penNumber)
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
    
    

