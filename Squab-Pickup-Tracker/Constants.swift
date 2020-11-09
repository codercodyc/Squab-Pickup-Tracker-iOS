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
    static let tableCellIdentifier = "PenCell"
    
    struct segue {
        static let segueToSelectionIdentifier = "toSelectionViewController"
        static let segueToPenSelectorIdentifier = "segueToPenSelector"
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
