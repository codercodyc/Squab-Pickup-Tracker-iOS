//
//  PickupSessionViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/14/20.
//

import UIKit
import CoreData

class PickupSessionViewController: UIViewController {
    
    var sessions = [Session]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedSession: Session?
    
    @IBOutlet weak var pickupSessionButton: UIButton!
    @IBOutlet weak var sessionTableView: UITableView!
    @IBOutlet weak var refreshDataButton: UIBarButtonItem!
    
    var pigeonDataManager = PigeonDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionTableView.delegate = self
        sessionTableView.dataSource = self
        
        sessionTableView.backgroundColor = .none

        pigeonDataManager.delegate = self
        
        navigationItem.title = "Pickup Session"
        
        
        pickupSessionButton.layer.cornerRadius = pickupSessionButton.frame.height / 2
        pickupSessionButton.layer.shadowColor = UIColor.black.cgColor
        pickupSessionButton.layer.shadowOpacity = 0.5
        pickupSessionButton.layer.shadowOffset = .init(width: 0, height: 4)
        pickupSessionButton.layer.shadowRadius = 10
        
//        print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask))
        
        loadSessions()

       
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.isNavigationBarHidden = true
        sessionTableView.reloadData()
    }
    
    func addBlankSession() {
        let newSession: Session = Session(context: context)
        newSession.dateCreated = Date()
        newSession.wasCreated = true
        //print(newSession.dateCreated!)
        
        for pen in K.penIDs {
            let newPen = Pen(context: context)
            newPen.id = pen
            
            for nest in K.nestIDs {
                let newNest = Nest(context: context)
                newNest.id = nest
                newPen.addToNests(newNest)
            }
            
            newSession.addToPens(newPen)
            
        }
        
        
        sessions.insert(newSession, at: 0)
        //selectedSession = pickupSessions.last
        saveSessions()
        selectedSession = sessions[0]
        
    }

    
    
    //MARK: - Button Actions
    

    @IBAction func pickupSessionPressed(_ sender: UIButton) {
        addBlankSession()
        
        performSegue(withIdentifier: K.segue.pickupPens, sender: self)
        
    }
    
    
    @IBAction func trashButtonPressed(_ sender: UIBarButtonItem) {
        var sessionsToDelete = [Session]()
        
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        let predicate = NSPredicate(format: "wasCreated = NO")
        request.predicate = predicate
        
        do {
            sessionsToDelete =  try context.fetch(request)
        } catch {
            print("Error deleting context \(error)")
        }
        
        for session in sessionsToDelete {
            context.delete(session)
        }
        saveSessions()
        loadSessions()
        
    }
    
    
    //MARK: - Refresh API Pressed
    
    @IBAction func refreshPressed(_ sender: UIBarButtonItem) {
        pigeonDataManager.downloadData()
        
    }
    
    
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.pickupPens {
            let destinationVC = segue.destination as! PickupPenViewController
            destinationVC.selectedSesssion = selectedSession
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
    
    func loadSessions() {
        let sortDescending = NSSortDescriptor(key: "dateCreated", ascending: false)
        
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        request.sortDescriptors = [sortDescending]
        
        do {
            sessions = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        sessionTableView.reloadData()
    }
    

}

//MARK: - UITableViewDataSource

extension PickupSessionViewController: UITableViewDataSource {
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
            if sessions[indexPath.row].wasCreated {
                safeCell.backgroundColor = .clear
            } else {
                safeCell.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
            }
            cell = safeCell
        }
        
        return cell
        
    }
    
    
}

//MARK: - UITableViewDelegate

extension PickupSessionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
}

//MARK: - PigeonDataManagerDelegate

extension PickupSessionViewController: PigeonDataManagerDelegate {
    func didDownloadData(data: PigeonData?) {
        print("downloaded data")
        loadSessions()
        

    }
    
    func didFailWithError(error: Error) {
        print("JSON Parsing error \(error)")
    }
    
    
    func didSubmitSession() {
        print("Submitted Session")
    }
    
    
}
