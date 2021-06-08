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
    static let sessionCell = "sessionCell"
    static let MoveCullCellIdentifier = "MoveCullCell"
    static let ProductionByWeekCellIdentifier = "ProductionCell"
    static let ProductionCellNibName = "ProductionByPairTableViewCell"
    static let ProductionCullCell = "ProductionCullCell"
    static let cullCellIdentifier = "cullCell"
    
    static let liveServerStatusKey = "liveServerStatus"
    
    static let nestIDs = ["1A", "1B", "1C","2A","2B","2C","3A","3B","3C","4A","4B","4C","5A","5B","5C","6A","6B","6C","6D","7A","7B","7C","7D"]
    static let penIDs = [
        "305",
        "306",
        "307",
        "308",
        "318",
        "317",
        "316",
        "315",
        "401",
        "402",
        "403",
        "404",
        "405",
        "406",
        "407",
        "408",
        "409",
        "410",
        "420",
        "419",
        "418",
        "417",
        "416",
        "415",
        "414",
        "413",
        "412",
        "411",
        "501",
        "502",
        "503",
        "504",
        "505",
        "506",
        "507",
        "508",
        "509",
        "510",
        "520",
        "519",
        "518",
        "517",
        "516",
        "515",
        "514",
        "513",
        "512",
        "511",
    ]
    
    static let nestContents = [" " ,"Clear", "E", "EE", "A", "AA", "B", "BB", "C", "CC", "D", "DD", "X", "XX", "Y", "YY", "1 Squab", "2 Squab"]
    
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
        " " : "none"
    ]
    
    
    struct segue {
        static let segueToSelectionIdentifier = "toSelectionViewController"
        static let segueToPenPopupIdentifier = "toPenPopup"
        static let dashboard = "toDashboard"
        static let pickupPens = "toPickupPens"
        static let pickupSettings = "toPickupSettings"
        static let datePicker = "toDatePicker"
    }
    
    
    struct color {
        static let cellDefault = "cellColor"
        static let cellEntered = "ContentsEntered"
        static let inventoryColor = "inventoryColor"
        static let deadColor = "deadColor"
        static let squabColor = "squabColor"
        static let highlightColor = "highlightColor"
        static let mainButton = "mainButtonColor"
    }
    
    
}
