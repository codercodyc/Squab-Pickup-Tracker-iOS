//
//  Feed DataManager.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/27/22.
//

import UIKit
import CoreData

protocol FeedDataManagerDelegate {
    func didFailWithError(error: Error)
    func didSubmitSession()
}

class FeedDataManager {
    
    
    // Post Feed Data to Database
    var sessionPostUrl: String {
        get {
            if UserDefaults.standard.bool(forKey: K.liveServerStatusKey) {
                //live
                return "https://dkcpigeons.com/api/post-new-feed-1wk"
            } else {
                //not live
                return "https://127.0.0.1:5000/api/post-new-feed-1wk"
            }
        }
    }
    
    var delegate: FeedDataManagerDelegate?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var currentSession: Session? {
        didSet {
//            encodeCurrentSession(with: currentSession!)
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

//MARK: - Get Feed Data From Session

    func feedDataFromSession(with session: Session) -> FeedData {

        
        
        var penData = [FeedPenData]()
        
        let submittedDateDouble = dateToDoubleWithoutTime(with: Date())
        let sessionDate = session.dateCreated!
        let newDateDouble = dateToDoubleWithoutTime(with: sessionDate)
        
        for pen in session.pens?.allObjects as! [Pen] {
            let currentPen = FeedPenData(penName: pen.id, cornScoops: Int(pen.cornScoops), pelletScoops: Int(pen.pelletScoops), feedEntryTime: submittedDateDouble)
            penData.append(currentPen)
//            nestData = []
            
        }
       
        
        
        let sessionData = FeedSessionData(date: newDateDouble, pens: penData)
        
        let feedData = FeedData(sessions: [sessionData], forceWrite: true)

//        print(feedData)
        return feedData
    }

    //MARK: - Encode Data and send out
    
    func encodeCurrentSession(with session: Session) {
        
        let feedData = feedDataFromSession(with: session)
        
        
        let encoder = JSONEncoder()
//        encoder.nil
        do {
            let data = try encoder.encode(feedData)
            postFeedSesion(jsonData: data)
//            let string = String(data: data, encoding: .utf8)!
//            print(string)
        } catch {
            delegate?.didFailWithError(error: error)
        }
        
        
        
        
    }


    
    //MARK: - Post Session
        func postFeedSesion(jsonData: Data) {
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
    //                        self.currentSession?.wasSubmitted = true
    //                        self.saveData()

                            self.delegate?.didSubmitSession()
                        } else {
                            print(responseData.statusCode)
                        }
                    }




                }
                task.resume()

            }
        }
}




