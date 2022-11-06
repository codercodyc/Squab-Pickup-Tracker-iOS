//
//  ErrorManager.swift
//  Squab-Pickup-Tracker
//
//  Created by Cody Crawmer on 11/5/22.
//

import Foundation

enum ErrorManager: Error {
    // throw when api fails to reach server
    case error404
    // generic error
    case unexpected
}

extension ErrorManager {
    var isFatal: Bool {
        if case ErrorManager.unexpected = self { return true }
        else {return false }
    }
}

extension ErrorManager: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .error404:
            return NSLocalizedString("Unable to connect to the server", comment: "Error 404")
        case .unexpected:
            return NSLocalizedString("An unexpected error occurred.", comment: "Unexpected Error")
        }
    }
}
