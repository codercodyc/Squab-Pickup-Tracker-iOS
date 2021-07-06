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
    func didSubmitTransfers()
    
}

class TransferDataManager {
    
    private let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let backgroundContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    
    var delegate: TransferDataManagerDelegate?
    
    // GET Transfer Data URL
    private var getTransferDataUrl: String {
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
    private var postTransferDataUrl: String {
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
            try self.context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        
    }
    
    /// - Tag: Loads all transfers, sorted by most recent
    
    func loadTranferData() -> [PairLocationChange]{
        let request: NSFetchRequest<PairLocationChange> = PairLocationChange.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        
        return [PairLocationChange]()
        
    }
    
    
    /// - Tag: Loads all transfers for pair ID
    
    func loadPairHistory(pairId: String) -> [PairLocationChange]{
        let request: NSFetchRequest<PairLocationChange> = PairLocationChange.fetchRequest()
        request.predicate = NSPredicate(format: "pairId == %@", pairId)
        request.sortDescriptors = [NSSortDescriptor(key: "eventDate", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }
        
        return [PairLocationChange]()
        
    }
    
    
    /// - Tag: Gets current nest for pair
    
    func currentNest(pairHistory: [PairLocationChange]) -> String? {
        // expects pair history to be sorted with newest first
        guard let date = pairHistory.first?.eventDate else {return nil}
        let recentTransactions = pairHistory.filter { transaction in
            return transaction.eventDate == date
        }
        
        for transaction in recentTransactions {
            if transaction.transferType != "Cull" {
                if transaction.inOut == "In" {
                    return transaction.penNest
                }
            }
        }
        return nil
    }
    
    
    func loadNestHistory(penNest: String) -> [PairLocationChange]? {
        let request: NSFetchRequest<PairLocationChange> = PairLocationChange.fetchRequest()
        request.predicate = NSPredicate(format: "penNest == %@", penNest)
//        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching context \(error)")
        }

        return nil
    }
    
    func pairIdForNest(penNest: String) -> String? {
        guard let transfers = loadNestHistory(penNest: penNest) else {return nil}
        guard let transfer = transfers.first else {return nil}
        print(transfer)
        if transfer.transferType == "New Pair" || transfer.transferType == "Move_In" {
            return String(transfer.pairId)
        }
        return nil
    }
    
    
    func isValidOpenNest(penNest: String) -> Bool {
        // first check if it is a valid nest at all
        let pen = penNest.components(separatedBy: "-")
//        print(pen)
        if pen.count == 2 {
            if K.penIDs.contains(pen[0]) && K.nestIDs.contains(pen[1]) {
                
            let pairId = pairIdForNest(penNest: penNest)
                if pairId == nil {
                    return true
                }
            }
        }
        
        
        return false
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
//                        print(json)
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
    
    
    // MARK: - Post Transfer Data
    func postTransfer(with transfer: TransferData) {
        
        guard let jsonData = encodeTransfer(with: transfer) else {return}
        print(jsonData)
        
        if let url = URL(string: postTransferDataUrl) {
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue(Keys.developmentKey, forHTTPHeaderField: "ApiKey")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let responseData = response as? HTTPURLResponse {
                    if responseData.statusCode == 200 {
                        // good
                        self.delegate?.didSubmitTransfers()
                    } else {
                        print(responseData.statusCode)
                    }
                }
                
            }
            
            task.resume()
        }
    }
    
    func encodeTransfer(with transfer: TransferData) -> Data? {
        let encoder = JSONEncoder()
        
        do {
            return try encoder.encode(transfer)
        } catch {
            delegate?.didFailWithError(error: error)
        }
        
        return nil
    }
    
    
//MARK: -  Update Tranfer Table in Database
    func updateTranferData(with data: JSON) {
        
        // Add all data to database
        for i in 0..<data.count {
            let newPairLocationChangeEntry = PairLocationChange(context: backgroundContext)
            
            newPairLocationChangeEntry.id = data[i]["id"].int16Value
            newPairLocationChangeEntry.pen = data[i]["pen"].string
            newPairLocationChangeEntry.pairId = data[i]["pairId"].int16Value
            newPairLocationChangeEntry.inOut = data[i]["inOut"].string
            newPairLocationChangeEntry.transferType = data[i]["transferType"].string
            newPairLocationChangeEntry.nest = data[i]["nest"].string
            newPairLocationChangeEntry.eventDate = data[i]["eventDate"].doubleValue
            newPairLocationChangeEntry.penNest = data[i]["penNest"].stringValue
            
//          saveData()
            
            do {
                try backgroundContext.save()
            } catch {
                print("Error saving context")
            }
//            saveData()
        }
        print("updated")
    }
    
    
    //MARK: - Delete Data
    func deleteTransferData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PairLocationChange")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
//        DispatchQueue.main.sync {
            do {
                    try backgroundContext.execute(deleteRequest)
                    self.saveData()
                print("deleted")
            } catch {
                print("Error deleting Transfer data \(error)")
            }
//        }
        
        
    }
    
    
    // MARK: - Get next Pair Id
    
    func getNewPairId() -> String {
        let request: NSFetchRequest<PairLocationChange> = PairLocationChange.fetchRequest()
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "pairId", ascending: false)]
        
        do {
            let transfer = try context.fetch(request)
            let newPairIdInt = transfer[0].pairId + 1
            return String(newPairIdInt)
        } catch {
            print("Error fetching context \(error)")
            delegate?.didFailWithError(error: error)
        }
        
        return "bad pair id"
        
    }
    


}
