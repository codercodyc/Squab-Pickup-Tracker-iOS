//
//  UrlManager.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/3/22.
//

import Foundation

    
enum Api_Urls : String {
    case post_device_user_info = "post-device-user-info"
    case get_device_user_info = "get-device-user-info"
    case get_prod_and_mort_1wk = "get-prod-and-mort-1wk"
    case post_new_prod_and_mort_1wk = "post-new-prod-and-mort-1wk"
    case get_pair_location_changesl = "get-pair-location-changes"
    case post_pair_location_changes = "post-pair-location-changes"
    case post_new_feed_1wk = "post-new-feed-1wk"
}

class UrlManager {
    
    let live_base = "https://dkcpigeons.com/api/"
    let dev_base = "https://pigeondash.ddctech.net/api/"
    let local_base = "http://127.0.0.1:5000/api/"
    
    /// Will return the string url for selected api route, directed to live or development server, based on current device settings.
    func urlFor(_ api : Api_Urls) -> String {
        if UserDefaults.standard.bool(forKey: K.liveServerStatusKey) {
            // live server enabled
//            print(live_base + api.rawValue)
            return live_base + api.rawValue
        } else {
            // not live server
//            print(dev_base + api.rawValue)
            return dev_base + api.rawValue
        }
    }
    
    /// Returns the development key from the environment variables
    func developmentKey() -> String {
        guard let key = ProcessInfo.processInfo.environment["API_KEY"] else {return ""}
//        print(key)
        return key
        
    }
    
    
    
}

