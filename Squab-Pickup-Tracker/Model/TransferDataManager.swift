//
//  TransferDataManager.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 6/16/21.
//

import UIKit
import CoreData

protocol TransferDataManagerDelegate {
    func didFailWithError(error: Error)
    
}

class TransferDataManager {
    
    private let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var delegate: TransferDataManagerDelegate?
    
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
            print("Error saving context")
        }
        
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
                
                if let safeData = data {
                    
                }
            }
        }
    }
    
    
//    func parseTransferData(_ data: Data) ->

}
