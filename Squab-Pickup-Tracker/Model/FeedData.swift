//
//  FeedData.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 10/27/22.
//

import Foundation

struct FeedData: Codable {
    let sessions: [FeedSessionData]
    let forceWrite: Bool?
    
}

struct FeedSessionData: Codable {
    let date: Double?
    let pens: [FeedPenData]
}


struct FeedPenData: Codable {
    let penName: String?
    let cornScoops: Int?
    let pelletScoops: Int?
    let feedEntryTime: Double?
}



