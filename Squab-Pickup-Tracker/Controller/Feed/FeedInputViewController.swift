//
//  FeedInputViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 8/20/22.
//

import UIKit
import CoreData

class FeedInputViewController: UIViewController {

    
    @IBOutlet weak var feedTypeSelector: UISegmentedControl!
    
    var penData = [Pen]()
    
    var selectedSession: Session? {
        didSet {
            loadPens()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func feedTypeChanged(_ sender: UISegmentedControl) {
        if feedTypeSelector.selectedSegmentIndex == 0 {
            feedTypeSelector.selectedSegmentTintColor = UIColor(named: "Corn")
        } else {
            feedTypeSelector.selectedSegmentTintColor = UIColor(named: "Pellets")
        }
        feedInputTableView.reloadData()
    }
    
    
    
    
   
    @IBOutlet weak var feedInputTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedInputTableView.delegate = self
        feedInputTableView.dataSource = self
        
    }
    

    //MARK: - Save and Load Methods

    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        feedInputTableView.reloadData()
    }

    func loadPens(with request: NSFetchRequest<Pen> = Pen.fetchRequest(), pen: String? = nil) {
        
        request.sortDescriptors = [NSSortDescriptor(key: "pickupOrderIndex", ascending: true)]
        
        let sessionPredicate = NSPredicate(format: "parentCategory.dateCreated == %@", selectedSession!.dateCreated! as CVarArg)
        
        
        request.predicate = sessionPredicate
        
        
        do {
            penData =  try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        
    }

}

//MARK: - UITableViewDataSource

extension FeedInputViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = selectedSession?.pens?.count ?? nil {
         return count
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if let safeCell = tableView.dequeueReusableCell(withIdentifier: K.penFeedCell) as? FeedInputTableViewCell {

            if feedTypeSelector.selectedSegmentIndex == 0 {
                safeCell.plusButton.tintColor = UIColor(named: "Corn")
                safeCell.minusButton.tintColor = UIColor(named: "Corn")
                safeCell.penLabel.text = penData[indexPath.row].id
                safeCell.scoopsLabel.text = String(penData[indexPath.row].cornScoops)
            } else {
                safeCell.plusButton.tintColor = UIColor(named: "Pellets")
                safeCell.minusButton.tintColor = UIColor(named: "Pellets")
                safeCell.penLabel.text = penData[indexPath.row].id
                safeCell.scoopsLabel.text = String(penData[indexPath.row].pelletScoops)
            }
         
            
            cell = safeCell
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    
}


//MARK: - UITableViewDelegate

extension FeedInputViewController: UITableViewDelegate {
    
}




