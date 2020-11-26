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
    func didSubmitSession()
}


class PigeonDataManager {
    //Phone
//    let LastWeekProductionUrl = "http://169.254.16:5000/api/get-prod-and-mort-1wk"
//    let sessionPostUrl = "http://169.254.16:5000/api/post-new-prod-and-mort-1wk"
    //Simulator
    let LastWeekProductionUrl = "http://127.0.0.1:5000/api/get-prod-and-mort-1wk"
    let sessionPostUrl = "http://127.0.0.1:5000/api/post-new-prod-and-mort-1wk"
    //Live Server
//    let LastWeekProductionUrl = "https://dkcpigeons.tk/api/get-prod-and-mort-1wk"
//    let sessionPostUrl = "https://dkcpigeons.tk/api/post-new-prod-and-mort-1wk"
    
    var delegate: PigeonDataManagerDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var currentSession: Session? {
        didSet {
            encodeCurrentSession(with: currentSession!)
        }
    }
    
   
    
    
    
    //MARK: - Pigeon Data API Call
    
    
    func downloadData() {
        if let url = URL(string: LastWeekProductionUrl) {

            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(Keys.developmentKey, forHTTPHeaderField: "ApiKey")
            
            let task = session.dataTask(with: request) { (data, response, error) in
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
                    } else if nest.nestEntryTime != nil {
                        newNest.dateModified = Date(timeIntervalSince1970: nest.nestEntryTime!)
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

        
        
        var nestData = [NestData]()
        var penData = [PenData]()
        
        
        
        for pen in session.pens?.allObjects as! [Pen] {
            for nest in pen.nests?.allObjects as! [Nest] {
                
                
                let currentNest = NestData(nestEntryTime: nest.dateModified?.timeIntervalSince1970 ?? 0, nestName: nest.id ?? "", nestProduction: Int(Int16(nest.productionAmount)) , nestInventoryCode: nest.inventoryCode ?? "", nestMortalityCode: nest.mortCode ?? "")
                nestData.append(currentNest)
            }
            let currentPen = PenData(nests: nestData, penName: pen.id)
            penData.append(currentPen)
            nestData = []
            
        }
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
//        dateFormatter.timeZone = TimeZone(abbreviation: "PT")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        let date = session.dateCreated
        let dateString = dateFormatter.string(from: date!)
        
//        let newFormatter = DateFormatter()
//        newFormatter.locale = Locale(identifier: "en_US")
//        newFormatter.setLocalizedDateFormatFromTemplate("MM/dd/yyyy'T'HH:mm:ssZ")
        
        let newDate = dateFormatter.date(from: dateString)
        let newDateDouble = newDate?.timeIntervalSince1970
//        print(dateString)
//        print(newDateDouble)
        
        
        let sessionData = SessionData(date: newDateDouble, pens: penData)
        
        let pigeonData = PigeonData(sessions: [sessionData], forceWrite: true)

        
        return pigeonData
    }
    
    
    //MARK: - Encode Data and send out
    
    func encodeCurrentSession(with session: Session) {
        
        let pigeonData = pigeonDataFromSession(with: session)
        
        
        let encoder = JSONEncoder()
//        encoder.nil
        do {
            let data = try encoder.encode(pigeonData)
            postSesion(jsonData: data)
//            let string = String(data: data, encoding: .utf8)!
//            print(string)
        } catch {
            delegate?.didFailWithError(error: error)
        }
        
        
        
        
    }
    
    

//MARK: - Post Session
    func postSesion(jsonData: Data) {
        if let url = URL(string: sessionPostUrl) {
            let session = URLSession.shared
            
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Keys.developmentKey, forHTTPHeaderField: "ApiKey")
            request.httpBody = jsonData
           
            
            
            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
                

                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let responseData = response as? HTTPURLResponse {
                    if responseData.statusCode == 200 {
                        self.delegate?.didSubmitSession()
                    } else {
                        print(responseData.statusCode)
                    }
                }
                

//                if let safeData = data {
//                    //print(safeData)
//                    if let pigeonData = self.parsePigeonData(safeData) {
//                        //print("parsed data")
//                        DispatchQueue.main.async {
//                            //self.addToDatabase(with: pigeonData)
                //self.delegate?.didDownloadData(data: pigeonData)
//
//                        }
//
//                    }
//
//                }

            }
            task.resume()
            
        }
    }

}
