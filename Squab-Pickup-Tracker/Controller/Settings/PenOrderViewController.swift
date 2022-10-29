//
//  PenOrderViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/28/22.
//

import UIKit

class PenOrderViewController: UIViewController {

//MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!

//MARK: - Parameters
    
    var penOrder: [String] = []
    let editButton = UIBarButtonItem()
    
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
//MARK: - App Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = penOrderType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditButton()
        tableView.delegate = self
        tableView.dataSource = self
    }

//MARK: - Functions
    func setupEditButton() {
        editButton.style = .plain
        editButton.action = #selector(editPressed)
        editButton.title = "Edit"
        editButton.target = self
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editPressed() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        editButton.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    func saveOrder() {
        if penOrderType == "Pickup Pen Order" {
            UserDefaults.standard.setValue(penOrder, forKey: K.pickupPenOrderKey)
        } else if penOrderType == "Feed Pen Order" {
            UserDefaults.standard.setValue(penOrder, forKey: K.feedPenOrderKey)
        }
        tableView.reloadData()
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

//MARK: - Table View Delegate Methods

extension PenOrderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let cellToMove = penOrder[sourceIndexPath.row]
        penOrder.remove(at: sourceIndexPath.row)
        penOrder.insert(cellToMove, at: destinationIndexPath.row)
        saveOrder()
    }
}
