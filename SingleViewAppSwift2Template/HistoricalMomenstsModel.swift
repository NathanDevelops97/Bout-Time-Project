//
//  HistoricalMomenstsModel.swift
//  SingleViewAppSwift2Template
//
//  Created by Nathanael Grant on 9/26/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import Foundation
import GameKit

class HistoricalMoment {
    
    var event: String
    var year: Int
    
    
    init(event: String, year: Int) {
        
        self.event = event
        self.year = year
    }
}



// Error Types

enum EventError: Error {
    case InvalidDate
    case InvalidEvent
}





// Helper Classes

class PlistConverter {
    class func arrayFromFile(resource: String, ofType type: String) throws -> [[String : String]] {
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
            throw EventError.InvalidDate
        }
        
        guard let array = NSArray(contentsOfFile: path), let castArray = array as? [[String : String]] else {
            throw EventError.InvalidEvent
        }
        
        return castArray
    }
}



class PlistUnarchiver {
    class func createListFromArray(array: [[String: String]]) -> [HistoricalMoment] {
        var listOfInventions: [HistoricalMoment] = []
        
        for invention in array {
            if let event = invention["event"], let year = invention["year"], let yearAsNumber = Int(year) {
                let invention = HistoricalMoment(event: event, year: yearAsNumber)
                listOfInventions.append(invention)
            }
        }
        
        return listOfInventions
}
}
