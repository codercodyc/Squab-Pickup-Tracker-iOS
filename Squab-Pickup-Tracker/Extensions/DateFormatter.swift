//
//  DateFormatter.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 7/5/21.
//

import Foundation


func dateToDoubleWithoutTime(with date: Date) -> Double? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US")
    dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
    let dateString = dateFormatter.string(from: date)
    let newDate = dateFormatter.date(from: dateString)
    return newDate?.timeIntervalSince1970
}
