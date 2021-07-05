//
//  TransferData.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 7/5/21.
//

import Foundation

struct TransferData: Codable {
    let pairLocationChanges: [Transfer]
}

struct Transfer: Codable {
    let pairId: String
    let penNest: String
    let transferType: String
    let inOut: String
    let eventDate: Double
}
