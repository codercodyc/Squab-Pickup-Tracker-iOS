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
    
    func displayTransferInputError(error: String?, inputField: InputFields)
    
}

enum InputFields: String {
    case pairId
    case to
    case from
}


class TransferDataManager {
    
    private let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let backgroundContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
    
    var delegate: TransferDataManagerDelegate?
    
    let urlManager = UrlManager()
    


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
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            delegate?.didFailWithError(error: error)
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
                    delegate?.displayTransferInputError(error: nil, inputField: .from)
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
    
    func isValidFilledNest(penNest: String) -> String? {
        let pen = penNest.components(separatedBy: "-")
        if pen.count != 2 {
            delegate?.displayTransferInputError(error: "Enter pen-nest (503-2A)", inputField: .from)
            return nil
        }
        
        // Check that pen and nest are contained in constants list
        if !K.penIDs.contains(pen[0]) {
            delegate?.displayTransferInputError(error: "Not a valid pen", inputField: .from)
            return nil
        }
        
        if !K.nestIDs.contains(pen[1]) {
            delegate?.displayTransferInputError(error: "Not a valid nest", inputField: .from)
            return nil
        }
        
        guard let pairId = pairIdForNest(penNest: penNest) else {
            delegate?.displayTransferInputError(error: "Empty Nest", inputField: .from)
            return nil
        }
        
        delegate?.displayTransferInputError(error: nil, inputField: .from)
        return pairId
    }
    
    func pairIdForNest(penNest: String) -> String? {
  
        guard let transfers = loadNestHistory(penNest: penNest) else {return nil}
        guard let transfer = transfers.first else {return nil}
        
        if transfer.transferType != "New Pair" && transfer.transferType != "Move_In" {
            return nil
        }
        
        delegate?.displayTransferInputError(error: nil, inputField: .from)
        return String(transfer.pairId)
    }
    
    
    func isValidOpenNest(penNest: String) -> Bool {
        
        
        // first check if it is a valid nest at all
        let pen = penNest.components(separatedBy: "-")
        if pen.count != 2 {
            delegate?.displayTransferInputError(error: "Enter pen-nest (503-2A)", inputField: .to)
            return false
        }
        
        // Check that pen and nest are contained in constants list
        if !K.penIDs.contains(pen[0]) {
            delegate?.displayTransferInputError(error: "Not a valid pen", inputField: .to)
            return false
        }
        
        if !K.nestIDs.contains(pen[1]) {
            delegate?.displayTransferInputError(error: "Not a valid nest", inputField: .to)
            return false
        }
        
        // check that nest is not already taken
        if pairIdForNest(penNest: penNest) != nil {
            delegate?.displayTransferInputError(error: "Nest already filled", inputField: .to)
            return false
        }
        // clear error message when valid input
        delegate?.displayTransferInputError(error: nil, inputField: .to)
        return true
    }
    
    
    // MARK: - GET Tranfer Data
    func getTranferData() {
        if let url = URL(string: urlManager.urlFor(Api_Urls.get_pair_location_changesl)) {
            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(urlManager.getApiKey(), forHTTPHeaderField: "ApiKey")
            
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil {
                    DispatchQueue.main.async {
                        self.delegate?.didFailWithError(error: error!)
                    }
                    return
                }
                
                if let safeData = data {
                    
                    do {
                        let json = try JSON(data: safeData)
                        // print(json)
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
                
            }
            task.resume()
        }
    }
    
    
    // MARK: - Post Transfer Data
    func postTransfer(with transfer: TransferData) {
        
        guard let jsonData = encodeTransfer(with: transfer) else {return}
        print(jsonData)
        
        if let url = URL(string: urlManager.urlFor(Api_Urls.post_pair_location_changes)) {
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue(urlManager.getApiKey(), forHTTPHeaderField: "ApiKey")
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
                        DispatchQueue.main.async {
                            self.delegate?.didSubmitTransfers()                            
                        }
                    } else {
                        if responseData.statusCode == 404 {
                            self.delegate?.didFailWithError(error: ErrorManager.error404)
                        } else {
                            self.delegate?.didFailWithError(error: ErrorManager.unexpected)
                        }
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
