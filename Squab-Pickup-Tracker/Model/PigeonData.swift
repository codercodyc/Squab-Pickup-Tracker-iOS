//
//  PigeonData.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit

class PigeonData {
    var pen: [Pen] = [Pen(id: "401")]
    
    
}

struct Pen {
    let id: String
    var nest: [Nest] = [Nest(id: "1A"), Nest(id: "1B"),Nest(id: "1C"),Nest(id: "2A"),Nest(id: "2B"),Nest(id: "2C"),Nest(id: "3A"),Nest(id: "3B"),Nest(id: "3C"),Nest(id: "4A"),Nest(id: "4B"),Nest(id: "4C"),Nest(id: "5A"),Nest(id: "5B"),Nest(id: "5C"),Nest(id: "6A"),Nest(id: "6B"),Nest(id: "6C"),Nest(id: "7A"),Nest(id: "7B"),Nest(id: "7C"),Nest(id: "7D"),]
}

struct Nest {
    let id: String
    var contents: String = ""
    var color = UIColor(named: K.color.cellDefault)
}
