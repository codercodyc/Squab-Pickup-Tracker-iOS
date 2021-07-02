//
//  TransferDataManager.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/16/21.
//

import UIKit
import CoreData
import SwiftyJSON

protocol TransferDataManagerDelegate {
    func didFailWithError(error: Error)
    func didDownloadTransfers()
//    func didLoadTransfers()
    
}

class TransferDataManager {
    
    private let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let backgroundContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    
    var delegate: TransferDataManagerDelegate?
    
    // GET Transfer Data URL
    var getTransferDataUrl: String {
        get {
            if UserDefaults.standard.bool(forKey: K.liveServerStatusKey) {
                print("using live database")
                return "https://dkcpigeons.tk/api/get-pair-location-changes"
            } else {
                print("using local database")
                return "http://127.0.0.1:5000/api/get-pair-location-changes"
            }
        }
    }
    
    // POST Transfer Data URL
    var postTransferDataUrl: String {
        get {
            if UserDefaults.standard.bool(forKey: K.liveServerStatusKey) {
                print("using live database")
                return "https://dkcpigeons.tk/api/post-pair-location-changes"
            } else {
                print("using local database")
                return "http://127.0.0.1:5000/api/post-pair-location-changes"
            }
        }
    }


    // MARK: - Data Manipulation Methods

    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    func loadTranferData() -> [PairLocationChange]{
        let request: NSFetchRequest<PairLocationChange> = PairLocationChange.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "pairId", ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        
        return [PairLocationChange]()
        
    }
    
    
    
    // MARK: - GET Tranfer Data
    func getTranferData() {
        if let url = URL(string: getTransferDataUrl) {
            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(Keys.developmentKey, forHTTPHeaderField: "ApiKey")
            
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                    do {
                            let json = try JSON(data: data!)
                        print(json["pairLocationChanges"][0])
                        let pairLocationChangeData = json["pairLocationChanges"]
                        DispatchQueue.global().sync {
                            self.deleteTransferData()
                            self.updateTranferData(with: pairLocationChangeData)
                            DispatchQueue.main.async {
                                self.delegate?.didDownloadTransfers()
                            }
                        }
                        
                    } catch {
                        print("Error parsing JSON \(error)")
                    }
            
                
            }
            task.resume()
        }
    }
    
    
//MARK: -  Update Tranfer Table in Database
    func updateTranferData(with data: JSON) {
        
        // Add all data to database
        for i in 0..<data.count {
            let newPairLocationChangeEntry = PairLocationChange(context: context)
            
            newPairLocationChangeEntry.id = data[i]["id"].int16Value
            newPairLocationChangeEntry.pen = data[i]["pen"].string
            newPairLocationChangeEntry.pairId = data[i]["pairId"].int16Value
            newPairLocationChangeEntry.inOut = data[i]["inOut"].string
            newPairLocationChangeEntry.transferType = data[i]["transferType"].string
            newPairLocationChangeEntry.nest = data[i]["nest"].string
            newPairLocationChangeEntry.eventDate = data[i]["eventDate"].doubleValue
            
//          saveData()
            
            do {
                try backgroundContext.save()
            } catch {
                print("Error saving context")
            }
        }
    }
    
    
    //MARK: - Delete Data
    func deleteTransferData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PairLocationChange")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try backgroundContext.execute(deleteRequest)
        } catch {
            print("Error deleting Transfer data \(error)")
        }
    }

}
