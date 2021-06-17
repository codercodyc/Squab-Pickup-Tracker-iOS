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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newPairButton.makeMainButton(fontSize: buttonFontSize)
        movePairButton.makeMainButton(fontSize: buttonFontSize)
        cullPairButton.makeMainButton(fontSize: buttonFontSize)
        
        transfersTableView.delegate = self
        transfersTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        let safeCell = transfersTableView.dequeueReusableCell(withIdentifier: "TransferCell", for: indexPath)
            safeCell.textLabel?.text = "\(indexPath.row)"
            cell = safeCell
        
        
        return cell
    }
    
    
}
