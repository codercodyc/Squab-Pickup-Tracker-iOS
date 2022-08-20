//
//  DatePickerViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/25/20.
//

import UIKit
import CoreData

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var selectedSession: Session?
    var sessionType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    @IBAction func cancelPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        let date = datePicker.date
        print(date)
        
        if sessionType == "Feed" {
            addBlankFeedSession(with: date)
            performSegue(withIdentifier: K.segue.feedPens, sender: self)
        } else if sessionType == "Pickup" {
            addBlankPickupSession(with: date)
            performSegue(withIdentifier: K.segue.pickupPens, sender: self)
        }
        
        
        
        
        
        
    }
    
    
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.segue.pickupPens {
            let destinationVC = segue.destination as! PickupPenViewController
            destinationVC.selectedSesssion = selectedSession
        }
        if segue.identifier == K.segue.feedPens {
            let destinationVC = segue.destination as! FeedInputViewController
            destinationVC.selectedSession = selectedSession
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
    
    //MARK: - AddBlankPickupSession
    
    
    func addBlankPickupSession(with date: Date) {
        
        let newSession: Session = Session(context: context)
        newSession.dateCreated = date
        newSession.wasCreated = true
        newSession.type = "Pickup"
        
        var pickupOrderCount = 0
        
        for pen in K.penIDs {
            let newPen = Pen(context: context)
            newPen.id = pen
            newPen.pickupOrderIndex = Int32(pickupOrderCount)
            pickupOrderCount = pickupOrderCount + 1
            
            for nest in K.nestIDs {
                let newNest = Nest(context: context)
                newNest.id = nest
                newPen.addToNests(newNest)
            }
            
            newSession.addToPens(newPen)
            
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-w"
//        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-w")
        newSession.baseWeek = dateFormatter.string(from: newSession.dateCreated!)
//        print(newSession.baseWeek!)
        
        
        selectedSession = newSession
        
        saveSessions()
        
    }
    
    
    //MARK: - AddBlankFeedSession
    
    
    func addBlankFeedSession(with date: Date) {
        
        let newSession: Session = Session(context: context)
        newSession.dateCreated = date
        newSession.wasCreated = true
        newSession.type = "Feed"
        
        var feedOrderCount = 0
        
        for pen in K.penIDs {
            let newPen = Pen(context: context)
            newPen.id = pen
            newPen.cornScoops = 0
            newPen.pelletScoops = 0
            
            newPen.feedOrderIndex = Int32(feedOrderCount)
            feedOrderCount = feedOrderCount + 1
            
            newSession.addToPens(newPen)
            
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-w"
//        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-w")
        newSession.baseWeek = dateFormatter.string(from: newSession.dateCreated!)
//        print(newSession.baseWeek!)
        
        
        selectedSession = newSession
        
        saveSessions()
        
    }
    
}


