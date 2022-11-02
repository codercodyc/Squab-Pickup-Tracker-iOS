//
//  NotificationManager.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/30/22.
//

import Foundation
import UserNotifications
import UIKit

protocol NotificationManagerDelegate {
    func didSubmitUserInfo()
    func didFailWithError(error: Error)
    
}

class NotificationManager {
    
//MARK: - Properties
    var deviceToken: String?
    
    var delegate: NotificationManagerDelegate?

// MARK: - API URLS
    
//    init(deviceToken: String) {
//        self.deviceToken = deviceToken
//    }
    
    var userInfoPostURL: String {
        get {
            if UserDefaults.standard.bool(forKey: K.liveServerStatusKey) {
                //live
                return "https://dev.dkcpigeons.com/api/post-device-user-info"  // Update
            } else {
                //not live
                return "https://dev.dkcpigeons.com/api/post-device-user-info"   // Update
            }
        }
    }
    
//MARK: - Post User Info
    
    func postUserInfo(jsonData: Data) {
        if let url = URL(string: userInfoPostURL) {
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

                        self.delegate?.didSubmitUserInfo()
                    } else {
                        print(responseData.statusCode)
                    }
                }




            }
            task.resume()

        }
    }
    
    
    func encodeUserInfo() {
        let deviceName = UIDevice.current.name
        guard let deviceToken = deviceToken else {
            return
        }
//        enableNotifications()
        let pickupStatus = UserDefaults.standard.bool(forKey: K.pickupNotificationsKey)
        let feedStatus = UserDefaults.standard.bool(forKey: K.feedNotificationsKey)

        let userInfo = UserInfo(deviceName: deviceName, deviceToken: deviceToken, pickupNotificationsEnabled: pickupStatus, feedNotificationsEnabled: feedStatus)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(userInfo)
            
            print(String(data: data, encoding: .utf8)!)
            postUserInfo(jsonData: data)
        } catch {
            delegate?.didFailWithError(error: error)
        }
        
    }
    
    func enableNotifications() {
        UserDefaults.standard.setValue(true, forKey: K.pickupNotificationsKey)
        UserDefaults.standard.setValue(true, forKey: K.feedNotificationsKey)
    }
    
    func disableNotifications() {
        UserDefaults.standard.setValue(false, forKey: K.pickupNotificationsKey)
        UserDefaults.standard.setValue(false, forKey: K.feedNotificationsKey)
    }
    
}
