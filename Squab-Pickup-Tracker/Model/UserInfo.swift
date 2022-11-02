//
//  UserInfo.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/30/22.
//

import Foundation

struct UserInfo: Codable {
    let deviceName: String
    let deviceToken: String
    let pickupNotificationsEnabled: Bool
    let feedNotificationsEnabled: Bool
}
