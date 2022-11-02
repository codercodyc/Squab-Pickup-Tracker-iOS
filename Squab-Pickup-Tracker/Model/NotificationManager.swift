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
    func didGetUserInfo(info: UserInfo)
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
    
    var userInfoGetURL: String {
        get {
            if UserDefaults.standard.bool(forKey: K.liveServerStatusKey) {
                //live
                return "https://dev.dkcpigeons.com/api/get-device-user-info"  // Update
            } else {
                //not live
                return "https://dev.dkcpigeons.com/api/get-device-user-info"   // Update
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
        print("encoding")
        let deviceName = UIDevice.current.name
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {return}
        let deviceToken = deviceToken ?? "unchanged"
//        enableNotifications()
        
        let pickupStatus = UserDefaults.standard.bool(forKey: K.pickupNotificationsKey)
        let feedStatus = UserDefaults.standard.bool(forKey: K.feedNotificationsKey)

        print("pickup: \(pickupStatus)")
        print("feed: \(feedStatus)")
        let userInfo = UserInfo(deviceId: deviceId, deviceName: deviceName, deviceToken: deviceToken, pickupNotificationsEnabled: pickupStatus, feedNotificationsEnabled: feedStatus)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(userInfo)
            
            print(String(data: data, encoding: .utf8)!)
            postUserInfo(jsonData: data)
        } catch {
            delegate?.didFailWithError(error: error)
        }
        
    }
    
//    func enableNotifications() {
//        UserDefaults.standard.setValue(true, forKey: K.pickupNotificationsKey)
//        UserDefaults.standard.setValue(true, forKey: K.feedNotificationsKey)
//    }
//
//    func disableNotifications() {
//        UserDefaults.standard.setValue(false, forKey: K.pickupNotificationsKey)
//        UserDefaults.standard.setValue(false, forKey: K.feedNotificationsKey)
//    }
    
    
//MARK: - Get User Info
    func getUserInfo() {
        guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
            print("error on device id")
            return
        }
        let queryParam = "?device_id=" + deviceId
        let fullUrl = userInfoGetURL + queryParam
        
        if let url = URL(string: fullUrl) {
            let session = URLSession.shared


            var request = URLRequest(url: url)
            request.httpMethod = "GET"
//            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue(Keys.developmentKey, forHTTPHeaderField: "ApiKey")
//            request.httpBody = jsonData



            let task = session.dataTask(with: request as URLRequest) { (data, response, error) in



                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
//                if let responseData = response as? HTTPURLResponse {
//                    if responseData.statusCode == 200 {
////                        self.currentSession?.wasSubmitted = true
////                        self.saveData()
//
//                        self.delegate?.didSubmitUserInfo()
//                    } else {
//                        print(responseData.statusCode)
//                    }
//                }
                
                if let safeData = data {
                    if let userInfo = self.parseUserData(safeData) {
                        DispatchQueue.main.async {
                            self.delegate?.didGetUserInfo(info: userInfo)
                        }
                        
                    }
                    
                }




            }
            task.resume()

        }
    }
    
    func parseUserData(_ data: Data) -> UserInfo? {
        let decoder = JSONDecoder()
        do {
            let decodedUserData = try decoder.decode(UserInfo.self, from: data)
            return decodedUserData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
//MARK: - Get Notification Setting from User Defaults
    func getDeviceSettings() -> [String: Bool] {
        let pickup = UserDefaults.standard.bool(forKey: K.pickupNotificationsKey)
        let feed = UserDefaults.standard.bool(forKey: K.feedNotificationsKey)
        
        return [K.pickupNotificationsKey: pickup, K.feedNotificationsKey: feed]
    }
    
    
}
