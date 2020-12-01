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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    @IBAction func cancelPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        let date = datePicker.date
        print(date)
        addBlankSession(with: date)
        
        performSegue(withIdentifier: K.segue.pickupPens, sender: self)
        
        
    }
    
    
    //MARK: - Prepare for Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! PickupPenViewController
        destinationVC.selectedSesssion = selectedSession
    }
    
    
    //MARK: - Data manipulation methods
    
    func saveSessions() {
        do {
            try context.save()
        } catch {
            print("Error saving context")
        }
        
    }
    
    //MARK: - AddBlankSession
    
    
    func addBlankSession(with date: Date) {
        
        let newSession: Session = Session(context: context)
        newSession.dateCreated = date
        newSession.wasCreated = true
        
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


