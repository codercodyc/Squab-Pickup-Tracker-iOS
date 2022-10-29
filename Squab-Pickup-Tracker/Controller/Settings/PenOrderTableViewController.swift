//
//  PenOrderTableViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/28/22.
//

import UIKit
//import CoreData

class PenOrderTableViewController: UITableViewController {
    
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
        
    var penOrder: [String] = []
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = penOrderType
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dragInteractionEnabled = true
        
        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return penOrder.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.penOrderCell, for: indexPath)

        cell.textLabel?.text = penOrder[indexPath.row]
        return cell
    }
    
    




}
