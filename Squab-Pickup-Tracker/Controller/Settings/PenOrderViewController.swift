//
//  PenOrderViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/28/22.
//

import UIKit

class PenOrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var penOrder: [String] = []
    
    var penOrderType: String = "" {
        didSet {
            print(penOrderType)
            if penOrderType == "Pickup Pen Order" {
                penOrder = UserDefaults.standard.stringArray(forKey: K.pickupPenOrderKey) ?? []
            } else if penOrderType == "Feed Pen Order" {
                penOrder = UserDefaults.standard.stringArray(forKey: K.feedPenOrderKey) ?? []
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = penOrderType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
    }
    
    
}


//MARK: - Table View Data Source Settings

extension PenOrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return penOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.penOrderCell, for: indexPath)

        cell.textLabel?.text = penOrder[indexPath.row]
        return cell
    }
    
}


extension PenOrderViewController: UITableViewDelegate {
    
}
