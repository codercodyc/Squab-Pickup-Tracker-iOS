//
//  UserInfo.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/30/22.
//

import Foundation

struct UserInfo: Codable {
    let deviceId: String
    let deviceName: String
    let deviceToken: String
    let pickupNotificationsEnabled: Bool
    let feedNotificationsEnabled: Bool
}

struct ServerInfo: Codable {
    let deviceId: String
    let active: Bool?
    let buildEnvironment: String
}
