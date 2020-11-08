//
//  PigeonData.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/7/20.
//

import UIKit

class PigeonData {
    var pen: [String: Pen] = ["401" : Pen()]
    
    
}

struct Pen {
    var nest: [String : Nest] = ["1A" : Nest(), "1B" : Nest(), "1C" : Nest(),"2A" : Nest(),"2B" : Nest(),"2C" : Nest(),"3A" : Nest(),"3B" : Nest(),"3C" : Nest(),"4A" : Nest(),"4B" : Nest(),"4C" : Nest(),"5A" : Nest(),"5B" : Nest(),"5C" : Nest(),"6A" : Nest(),"6B" : Nest(),"6C" : Nest(),"7A" : Nest(),"7B" : Nest(),"7C" : Nest(),"7D" : Nest()]
    
    //var nest: [String: Nest] = [Nest(id: "1A"), Nest(id: "1B"),Nest(id: "1C"),Nest(id: "2A"),Nest(id: "2B"),Nest(id: "2C"),Nest(id: "3A"),Nest(id: "3B"),Nest(id: "3C"),Nest(id: "4A"),Nest(id: "4B"),Nest(id: "4C"),Nest(id: "5A"),Nest(id: "5B"),Nest(id: "5C"),Nest(id: "6A"),Nest(id: "6B"),Nest(id: "6C"),Nest(id: "7A"),Nest(id: "7B"),Nest(id: "7C"),Nest(id: "7D"),]
}

struct Nest {
    var contents: String = ""
    var color = UIColor(named: K.color.cellDefault)
}
