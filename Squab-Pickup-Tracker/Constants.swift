//
//  File.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import Foundation

struct K {
    static let nestCellIdentifier = "nestCell"
    static let ContentsCellIdentifier = "ContentsCell"
    static let PenListCellIdentifier = "penListCell"
    
    static let nestIDs = ["1A", "1B", "1C","2A","2B","2C","3A","3B","3C","4A","4B","4C","5A","5B","5C","6A","6B","6C","7A","7B","7C","7D"]
    static let penIDs = ["401", "402", "403", "404", "405"]
    static let nestContents = ["" ,"Clear", "E", "EE", "A", "AA", "B", "BB", "C", "CC", "D", "DD", "X", "XX", "Y", "YY", "1 Squab", "2 Squab"]
    
    static let nestContentColors: [String: String] = [
        "E" : K.color.inventoryColor,
        "EE" : K.color.inventoryColor,
        "A" : K.color.inventoryColor,
        "AA" : K.color.inventoryColor,
        "B" : K.color.inventoryColor,
        "BB" : K.color.inventoryColor,
        "C" : K.color.inventoryColor,
        "CC" : K.color.inventoryColor,
        "D" : K.color.inventoryColor,
        "DD" : K.color.inventoryColor,
        "X" : K.color.deadColor,
        "XX" : K.color.deadColor,
        "Y" : K.color.deadColor,
        "YY" : K.color.deadColor,
        "1 Squab" : K.color.squabColor,
        "2 Squab"  : K.color.squabColor,
        "Clear" : K.color.cellDefault,
        "" : "none"
    ]
    
    
    struct segue {
        static let segueToSelectionIdentifier = "toSelectionViewController"
        static let segueToPenPopupIdentifier = "toPenPopup"
        static let dashboard = "toDashboard"
        static let pickupPens = "toPickupPens"
    }
    
    
    struct color {
        static let cellDefault = "cellColor"
        static let cellEntered = "ContentsEntered"
        static let inventoryColor = "inventoryColor"
        static let deadColor = "deadColor"
        static let squabColor = "squabColor"
        static let highlightColor = "highlightColor"
    }
    
    
}
