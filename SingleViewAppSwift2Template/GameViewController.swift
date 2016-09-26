//
//  ViewController.swift
//  SingleViewAppSwift2Template
//
//  Created by Treehouse on 9/19/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import Foundation
import GameKit
//

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        showAlert("How to play: In the game you are given certain inventions. Re-order so Oldest is on top. You will have 6 rounds!")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Protocols
    
    protocol EventType {
        var event: String { get }
        var year: String { get }
    }
    
    // Cases for each item in plist
    
    enum historicalEvents: String {
        
        case item1
        case item2
        case item3
        case item4
        case item5
        case item6
        case item7
        case item8
        case item9
        case item10
        case item11
        case item12
        case item13
        case item14
        case item15
        case item16
        case item17
        case item18
        case item19
        case item20
        case item21
        case item22
        case item23
        case item24
        case item25
        
        
    }
    
    
    
    struct EventItem: EventType {
        let event: String
        var year: String
        
    }
    
    
    // Error Types
    
    enum EventError: Error {
        case invalidDate
        case invalidEvent
    }
    
    
    // Get data from plist
    
    class PlistConverter {
        
        class func dictionaryFromFile(_ resource: String,  ofType type: String) throws -> [String : AnyObject] {
            
            guard let path = Bundle.main.path(forResource: resource, ofType: type) else {
                throw EventError.invalidDate
            }
            
            guard let dictionary = NSDictionary(contentsOfFile: path), let castDictionary = dictionary as? [String: AnyObject] else {
                
                throw EventError.invalidEvent
                
            }
            
            return castDictionary
            
        }
        
    }
    
    class InventoryUnarchiver {
        class func historicaleventsFromDictionary(_ dictionary: [String : AnyObject]) throws -> [historicalEvents : EventType] {
            var allEvents: [historicalEvents : EventType] = [:]
            
            for (key, value) in dictionary {
                if let itemDict = value as? [String : String], let event = itemDict["event"], let year = itemDict["year"] {
                    
                    let item = EventItem(event: event, year: year)
                    guard let key = historicalEvents(rawValue: key) else {
                        throw EventError.invalidEvent
                    }
                    
                    allEvents.updateValue(item, forKey: key)
                }
            }
            
            return allEvents
        }
    }
    
    
    func GetRandomQuestion() {
        
        
        
    }
    
    
    func DisplayQuestion() {
        
        
        
        
    }
    
    
    func reset() {
        
    }
    
    // Instructions Popup
    
    func showAlert(_ title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        
        let okAction = UIAlertAction(title: "How To Play", style: .default, handler: dismissAlert)
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        present(alertController, animated:  true, completion:  nil)
        
        alertController.addAction(okAction)
        
    }

    func dismissAlert(_ sender: UIAlertAction) {
        reset()
    }


}

