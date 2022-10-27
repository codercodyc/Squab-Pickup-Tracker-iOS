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
        loadSessions()
        
        navigationItem.title = "Feed Session"

        
    }
    @IBAction func NewFeedSessionPressed(_ sender: UIButton) {
        addBlankFeedSession()
        performSegue(withIdentifier: K.segue.datePicker, sender: self)
    }
    
    func addBlankFeedSession() {
        let newSession: Session = Session(context: context)
        newSession.dateCreated = Date()
        newSession.wasCreated = true
        newSession.type = "Feed"

        for pen in K.penIDs {
            let newPen = Pen(context: context)
            newPen.id = pen

            newSession.addToPens(newPen)

        }

        print(newSession)

        sessions.insert(newSession, at: 0)
        selectedSession = newSession
        saveSessions()
//        print("Added Session")
        selectedSession = sessions[0]
    }

    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.datePicker {
            let destinationVC = segue.destination as! DatePickerViewController
            destinationVC.sessionType = "Feed"
            destinationVC.selectedSession = selectedSession
            //print(pickupSessions.last?.dateCreated)
        }
    }


    //MARK: - Data manipulation methods

    func saveSessions() {
        do {
            try context.save()
        } catch {
            print("Error saving context")
        }
        
    }

//    func loadSessions() {
//        let sortDescending = NSSortDescriptor(key: "dateCreated", ascending: false)
//
//        let request: NSFetchRequest<Session> = Session.fetchRequest()
//        request.sortDescriptors = [sortDescending]
//
//        do {
//            sessions = try context.fetch(request)
//        } catch {
//            print("Error fetching context \(error)")
//        }
//        sessionTableView.reloadData()
//    }
    func loadSessions() {
        let sortDescending = NSSortDescriptor(key: "dateCreated", ascending: false)
        let sessionPredicate = NSPredicate(format: "type == %@", "Feed")
        
        
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.sortDescriptors = [sortDescending]
        request.predicate = sessionPredicate
        
        do {
            sessions = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        
        saveSessions()
        sessionTableView.reloadData()
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
        
        let alert = UIAlertController(title: titleText, message: "Are you sure you want to load this feed session?", preferredStyle: .alert)
        
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

