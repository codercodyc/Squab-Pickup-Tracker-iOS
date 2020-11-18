//
//  PigeonDataManager.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/16/20.
//

import UIKit

protocol PigeonDataManagerDelegate {
    func didDownloadData(data: PigeonData?)
    func didFailWithError(error: Error)
}


class PigeonDataManager {
    
    let LastWeekProductionUrl = "http://127.0.0.1:5000/api/get-production-1wk-array"
    
    var delegate: PigeonDataManagerDelegate?
    
    
   
    
    
    
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
                        self.delegate?.didDownloadData(data: pigeonData)
                        addToDatabase(with: pigeonData)
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
    
    
    //MARK: - Add Data to Database
    
    func addToDatabase(with data: PigeonData) {
        
        
        
    }

    
}
