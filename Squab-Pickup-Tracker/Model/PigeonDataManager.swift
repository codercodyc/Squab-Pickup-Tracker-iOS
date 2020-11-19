//
//  PigeonDataManager.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/16/20.
//

import UIKit
import CoreData

protocol PigeonDataManagerDelegate {
    func didDownloadData(data: PigeonData?)
    func didFailWithError(error: Error)
}


class PigeonDataManager {
    
    let LastWeekProductionUrl = "http://127.0.0.1:5000/api/get-prod-and-mort-1wk"
    
    var delegate: PigeonDataManagerDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var currentSession: Session? {
        didSet {
            exportCurrentSession(with: currentSession!)
        }
    }
    
   
    
    
    
    //MARK: - Pigeon Data API Call
    
    
    func downloadData() {
        if let url = URL(string: LastWeekProductionUrl) {

            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let pigeonData = self.parsePigeonData(safeData) {
                        DispatchQueue.main.async {
                            self.addToDatabase(with: pigeonData)
                            self.delegate?.didDownloadData(data: pigeonData)
                        }
                        
                    }
                    
                }
            }
            
            task.resume()
        }
  
    }
    
    
    
    func parsePigeonData(_ data: Data) -> PigeonData? {
        let decoder = JSONDecoder()
        do {
            let decodedProductionData = try decoder.decode(PigeonData.self, from: data)
            return decodedProductionData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //MARK: - Data Manipulation Methods
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context")
        }
        
    }
    
    
    //MARK: - Add Data to Database
    
    func addToDatabase(with data: PigeonData) {
        
        
        // do for loop over sessions
        let newSession = Session(context: self.context)
        //let dateFormatter = DateFormatter()
        
        //        dateFormatter.locale = Locale(identifier: "en_US")
        //        dateFormatter.setLocalizedDateFormatFromTemplate("E, dd MMM YYYY hh:mm:ss zzz")
        //        let date = dateFormatter.date(from: data.session)
        
        newSession.dateCreated = Date()
        newSession.wasCreated = false
        
        
        for session in data.sessions {
            newSession.dateCreated = Date.init(timeIntervalSince1970: session.date!)
            
            for pen in session.pens {
                let newPen = Pen(context: context)
                newPen.id = pen.penName
                
                for nest in pen.nests {
                    let newNest = Nest(context: context)
                    newNest.id = nest.nestName
                    
                    if nest.nestProduction != 0 {
                        newNest.productionAmount = Int16(nest.nestProduction ?? 0)
                        newNest.color = K.color.squabColor
                    } else if nest.nestInventoryCode != "" {
                        newNest.inventoryCode = nest.nestInventoryCode
                        newNest.color = K.color.inventoryColor
                    } else if nest.nestMortalityCode != "" {
                        newNest.mortCode = nest.nestMortalityCode
                        newNest.color = K.color.deadColor
                    }
                    
                    newPen.addToNests(newNest)
                }
                newSession.addToPens(newPen)
                
            }
            
        }
        
        
        
        
        
        
        self.saveData()
        
        
        
    }
    
    //MARK: - PigeonDataFromSession
    func pigeonDataFromSession(with session: Session) -> PigeonData {
//        var nestData = [NestData(nestName: "", nestProduction: 0, nestInventoryCode: "", nestMortalityCode: "")]
//        var penData = [PenData(nests: nestData, penName: "")]
//        var sessionData = SessionData(date: 0.0, pens: penData)
//        var pigeonData = PigeonData(sessions: [sessionData])
//
//
        var nestData = [NestData]()
        var penData = [PenData]()
        
        
        
        for pen in session.pens?.allObjects as! [Pen] {
            for nest in pen.nests?.allObjects as! [Nest] {
                
                let currentNest = NestData(nestName: nest.id ?? "", nestProduction: Int(Int16(nest.productionAmount)) , nestInventoryCode: nest.inventoryCode ?? "", nestMortalityCode: nest.mortCode ?? "")
                nestData.append(currentNest)
            }
            let currentPen = PenData(nests: nestData, penName: pen.id)
            penData.append(currentPen)
            
        }
        
        let sessionData = SessionData(date: session.dateCreated?.timeIntervalSince1970, pens: penData)
        
        let pigeonData = PigeonData(sessions: [sessionData])
        
        
        
        
        return pigeonData
    }
    
    
    //MARK: - Encode Data and send out
    
    func exportCurrentSession(with session: Session) {
        
        let pigeonData = pigeonDataFromSession(with: session)
        
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(pigeonData)
            let string = String(data: data, encoding: .utf8)!
            print(string)
        } catch {
            print("Error encoding pigeonData \(error)")
        }
        
        
        
        
    }
    
    
}
