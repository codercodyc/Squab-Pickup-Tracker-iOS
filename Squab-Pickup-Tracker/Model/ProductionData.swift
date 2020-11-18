//
//  ProductionData.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/16/20.
//

import Foundation

struct ProductionData: Decodable {
    let session: String
    let pens: [PenData]
}


struct PenData: Decodable {
    let nests: [NestData]
    let penName: String
}

struct NestData: Decodable {
    let nestName: String
    let production: Int
}
