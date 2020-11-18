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
    
    let LastWeekProductionUrl = "http://127.0.0.1:5000/api/get-production-1wk-array"
    
    var delegate: PigeonDataManagerDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    
   
    
    
    
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
        
        
        
        for pen in data.pens {
            let newPen = Pen(context: context)
            newPen.id = pen.penName
            
            for nest in pen.nests {
                let newNest = Nest(context: context)
                newNest.id = nest.nestName
                newNest.productionAmount = Int16(nest.production)
                newNest.color = K.color.squabColor
                newPen.addToNests(newNest)
            }
            newSession.addToPens(newPen)
            
        }
        
        
        
        
        self.saveData()
        
        
        
    }
    
    
}
