//
//  TransfersViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/15/21.
//

import UIKit

class TransfersViewController: UIViewController {

    @IBOutlet weak var newPairButton: UIButton!
    @IBOutlet weak var movePairButton: UIButton!
    @IBOutlet weak var cullPairButton: UIButton!
    @IBOutlet weak var transfersTableView: UITableView!
    
    private let buttonFontSize: CGFloat = 20
    
    // Create Instance of TransferDataManager
    private let transferDataManager = TransferDataManager()
    
    private var pairLocationData = [PairLocationChange]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newPairButton.makeMainButton(fontSize: buttonFontSize)
        movePairButton.makeMainButton(fontSize: buttonFontSize)
        cullPairButton.makeMainButton(fontSize: buttonFontSize)
        
        transfersTableView.delegate = self
        transfersTableView.dataSource = self
        
        transferDataManager.delegate = self
        
        refreshTransferData()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async {
            self.transferDataManager.getTranferData()

        }
        self.refreshTransferData()
        transfersTableView.reloadData()
        
        
    }
    
    @IBAction func newPairPessed(_ sender: UIButton) {
    }
    
    @IBAction func movePairPressed(_ sender: UIButton) {
    }
    
    @IBAction func cullPairPressed(_ sender: UIButton) {
    }
}


extension TransfersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pairLocationData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = UITableViewCell()
        
        let safeCell = transfersTableView.dequeueReusableCell(withIdentifier: "TransferCell", for: indexPath)
        
        var cellText = "Pair Id: \(pairLocationData[indexPath.row].pairId)"
        cellText += " Transfer Type: \(pairLocationData[indexPath.row].transferType ?? "")"
        cellText += " In/Out: \(pairLocationData[indexPath.row].inOut ?? "")"
        
        safeCell.textLabel?.text = cellText
        safeCell.textLabel?.adjustsFontSizeToFitWidth = true
        
        cell = safeCell
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Refresh Data
    private func refreshTransferData() {
        self.pairLocationData = self.transferDataManager.loadTranferData()
        
    }
    
    
}


// MARK: - TransferDataManagerDelegate Methods

extension TransfersViewController: TransferDataManagerDelegate {
    func didFailWithError(error: Error) {
        print("Tranfer GET request failed \(error)")
    }
}
