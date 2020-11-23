//
//  ProductionData.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/16/20.
//

import Foundation

struct PigeonData: Codable {
    let sessions: [SessionData]
    let forceWrite: Bool?
    
}

struct SessionData: Codable {
    let date: Double?
    let pens: [PenData]
}


struct PenData: Codable {
    let nests: [NestData]
    let penName: String?
}

struct NestData: Codable {
    let nestEntryTime: Double!
    let nestName: String?
    let nestProduction: Int?
    let nestInventoryCode: String?
    let nestMortalityCode: String?
}
