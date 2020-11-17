//
//  PigeonDataManager.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/16/20.
//

import UIKit

protocol PigeonDataManagerDelegate {
    func didDownloadData(data: String?)
    func didFailWithError(error: Error)
}


class PigeonDataManager {
    
    let LastWeekProductionUrl = "http://127.0.0.1:5000/api/get-production-1wk"
    
    var delegate: PigeonDataManagerDelegate?
    
    
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
                        self.delegate?.didDownloadData(data: pigeonData)
                    }
                    //perform parsing function
                }
            }
            
            task.resume()
        }
  
    }
    
    
    
    func parsePigeonData(_ data: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let decodedProductionData = try decoder.decode(ProductionData.self, from: data)
            let currentSession = decodedProductionData.session
            return currentSession
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

    
}
