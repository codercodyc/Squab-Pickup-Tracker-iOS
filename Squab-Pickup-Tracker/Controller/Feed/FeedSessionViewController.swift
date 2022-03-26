//
//  FeedSessionViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 1/10/22.
//

import UIKit
import CoreData

class FeedSessionViewController: UIViewController {
    
    var sessions = [Session]()
    var selectedSession: Session?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var feedSessionButton: UIButton!
    @IBOutlet weak var sessionTableView: UITableView!
    
    var pigeonDataManager = PigeonDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedSessionButton.makeMainButton(fontSize: 20)
        sessionTableView.delegate = self
        sessionTableView.dataSource = self
        sessionTableView.backgroundColor = .none
        
        navigationItem.title = "Feed Session"

        
    }
    


}


//MARK: - UITableViewDataSource

extension FeedSessionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d, yyyy, h:mm a")

        let date = sessions[indexPath.row].dateCreated!
        let dateString = dateFormatter.string(from: date)
        
        
        
        var cell = UITableViewCell()
        if let safeCell = tableView.dequeueReusableCell(withIdentifier: K.sessionCell) {
            safeCell.textLabel?.text = dateString
            safeCell.textLabel?.font.withSize(15)
            safeCell.textLabel?.adjustsFontSizeToFitWidth = true
            if sessions[indexPath.row].wasSubmitted && sessions[indexPath.row].wasCreated == false {
                safeCell.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            } else if sessions[indexPath.row].wasSubmitted {
                safeCell.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            } else if sessions[indexPath.row].wasCreated == false {
                safeCell.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            } else {
                safeCell.backgroundColor = UIColor(named: "sessionCell")
                safeCell.textLabel?.textColor = .label
                
            }
            cell = safeCell
        }
        
        return cell
        
    }
    
    
}

//MARK: - UITableViewDelegate

extension FeedSessionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let titleText = sessionTableView.cellForRow(at: indexPath)?.textLabel?.text
        
        let alert = UIAlertController(title: titleText, message: "Are you sure you want to load this pickup session?", preferredStyle: .alert)
        
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (action) in
            self.selectedSession = self.sessions[indexPath.row]
            self.performSegue(withIdentifier: K.segue.pickupPens, sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            tableView.deselectRow(at: indexPath, animated: true)

        }
        
       
        
        alert.addAction(cancelAction)
        alert.addAction(continueAction)
     
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

