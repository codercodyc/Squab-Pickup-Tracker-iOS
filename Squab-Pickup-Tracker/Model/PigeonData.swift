//
//  PigeonData.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit

struct PigeonData {
    var pen: [String: Pen] = ["401" : Pen(), "402" : Pen(), "403" : Pen(), "404" : Pen()]
    
    var penNames: [String] {
        return Array(pen.keys.sorted())
    }
    var currentPen: String {
        return penNames[0]
    }
    
    
}

struct Pen {
    var nest: [String : Nest] = ["1A" : Nest(),
                                 "1B" : Nest(),
                                 "1C" : Nest(),
                                 "2A" : Nest(),
                                 "2B" : Nest(),
                                 "2C" : Nest(),
                                 "3A" : Nest(),
                                 "3B" : Nest(),
                                 "3C" : Nest(),
                                 "4A" : Nest(),
                                 "4B" : Nest(),
                                 "4C" : Nest(),
                                 "5A" : Nest(),
                                 "5B" : Nest(),
                                 "5C" : Nest(),
                                 "6A" : Nest(),
                                 "6B" : Nest(),
                                 "6C" : Nest(),
                                 "7A" : Nest(),
                                 "7B" : Nest(),
                                 "7C" : Nest(),
                                 "7D" : Nest()
    ]
    
    
}

struct Nest {
    var contents: String = ""
    var color = UIColor(named: K.color.cellDefault)
    var isMostRecent = false
}
