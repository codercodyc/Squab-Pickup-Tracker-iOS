//
//  PickupSessionViewController.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/14/20.
//

import UIKit
import CoreData

class PickupSessionViewController: UIViewController {
    
    var pickupSessions = [Session]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
    @IBOutlet weak var pickupSessionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickupSessionButton.layer.cornerRadius = pickupSessionButton.frame.height / 2
        pickupSessionButton.layer.shadowColor = UIColor.black.cgColor
        pickupSessionButton.layer.shadowOpacity = 0.5
        pickupSessionButton.layer.shadowOffset = .init(width: 0, height: 4)
        pickupSessionButton.layer.shadowRadius = 10
        
        print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask))
        
        loadSession()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Button Actions
    

    @IBAction func pickupSessionPressed(_ sender: UIButton) {
        let newSession: Session = Session(context: context)
        newSession.dateCreated = Date.init()
        print(newSession.dateCreated!)
        
        for pen in K.penIDs {
            let newPen = PenClass(context: context)
            newPen.id = pen
            
            for nest in K.nestIDs {
                let newNest = NestClass(context: context)
                newNest.id = nest
                newPen.addToNests(newNest)
            }
            
            newSession.addToPens(newPen)
            
        }

        pickupSessions.append(newSession)
        //selectedSession = pickupSessions.last
        saveSessions()
        
        performSegue(withIdentifier: K.segue.pickupPens, sender: self)
        
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.pickupPens {
            let destinationVC = segue.destination as! PickupPenViewController
            
            destinationVC.selectedSesssion = pickupSessions.last
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
    
    func loadSession() {
        let request: NSFetchRequest<Session> = Session.fetchRequest()
        
        do {
            pickupSessions = try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
    }
    

}
