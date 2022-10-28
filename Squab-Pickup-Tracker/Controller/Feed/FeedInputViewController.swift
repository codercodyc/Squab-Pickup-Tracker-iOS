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
    var feedManager = FeedDataManager()
    
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
    
    
    @IBAction func gearPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let submit = UIAlertAction(title: "Submit Feed Session", style: .default) { (action) in
            self.submitSession()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let exit = UIAlertAction(title: "Exit to Menu", style: .destructive) { action in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(submit)
        alert.addAction(exit)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func submitSession() {
        let alert = UIAlertController(title: "Submit Feed Session", message: "Are you sure you want to submit this feed session?", preferredStyle: .alert)
        let submit = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.postFeedData()
        }
        let cancel = UIAlertAction(title: "No", style: .destructive, handler: nil)
        alert.addAction(submit)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Post Feed Data
    
    func postFeedData() {
        if selectedSession?.wasSubmitted == true {
            let alert = UIAlertController(title: "Session has already been submitted", message: "", preferredStyle: .alert)
            
            let submit = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                
            }
            
            
            alert.addAction(submit)
            
            self.present(alert, animated: true, completion: nil)
        } else {
            if let currentSession = selectedSession {
                DispatchQueue.main.async {
                    self.feedManager.encodeCurrentSession(with: currentSession)
                    
                }
            }
        
        }
    }
    
    
   //MARK: - Table View Methods
    @IBOutlet weak var feedInputTableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedInputTableView.delegate = self
        feedInputTableView.dataSource = self
        
        feedManager.delegate = self
        
    }
    @IBAction func buttonPressed(_ sender: UIButton) {
        var superview = sender.superview?.superview
        while let view = superview, !(view is UITableViewCell) {
            superview = view.superview
        }
        guard let cell = superview as? UITableViewCell else {
            print("error")
            return
        }
        guard let index = feedInputTableView.indexPath(for: cell)?.row else {
            print("error")
            return
        }
        
        if feedTypeSelector.selectedSegmentIndex == 0 { // Corn
            if sender.tag == 0 { //Plus
                penData[index].cornScoops += 1
            } else if sender.tag == 1 { //Minus
                if(penData[index].cornScoops == 0) {
                    return
                } else {
                    penData[index].cornScoops -= 1
                }
            }
        } else { // Pellets
            if sender.tag == 0 { //Plus
                penData[index].pelletScoops += 1
            } else if sender.tag == 1 { //Minus
                if (penData[index].pelletScoops == 0) {
                    return
                }
                penData[index].pelletScoops -= 1
            }
        }
        saveData()	
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
        
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
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
                let scoops = penData[indexPath.row].cornScoops
                if scoops == 0 {
                    safeCell.scoopsLabel.text = "-"
                    safeCell.scoopsLabel.textColor = .lightGray
                } else {
                    safeCell.scoopsLabel.textColor = .label

                    safeCell.scoopsLabel.text = String(scoops)
                }
            } else {
                safeCell.plusButton.tintColor = UIColor(named: "Pellets")
                safeCell.minusButton.tintColor = UIColor(named: "Pellets")
                safeCell.penLabel.text = penData[indexPath.row].id
                let scoops = penData[indexPath.row].pelletScoops
                if scoops == 0 {
                    safeCell.scoopsLabel.text = "-"
                    safeCell.scoopsLabel.textColor = .lightGray
                } else {
                    safeCell.scoopsLabel.textColor = .label
                    safeCell.scoopsLabel.text = String(scoops)
                }
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

//MARK: - FeedDataManager Delegate
extension FeedInputViewController: FeedDataManagerDelegate {
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            
            
            let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                
                
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func didSubmitSession() {
        DispatchQueue.main.async {
            
            
            // update session submission
            self.selectedSession?.wasSubmitted = true
            self.saveData()
            
            let alert = UIAlertController(title: "Session Submitted", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                
                
                self.dismiss(animated: true, completion: nil)
                
                self.navigationController?.popToRootViewController(animated: true)
                
            }
            
            
            
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}




