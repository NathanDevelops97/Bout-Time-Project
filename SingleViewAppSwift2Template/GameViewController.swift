//
//  ViewController.swift
//  SingleViewAppSwift2Template
//
//  Created by Treehouse on 9/19/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import AudioToolbox
import GameKit


class ViewController: UIViewController {
    
    // Game Properties
    
    var listOfInventions: [HistoricalMoment] = []
    var roundsPlayed = 0
    var roundsCorrect = 0
    var totalRounds = 6
    var setOfInventions: [HistoricalMoment] = []
    var setOfInventionsInOrder: [HistoricalMoment] = []
    var copyOfListOfInventions: [HistoricalMoment] = []
    
    //Setup variables for each of the 4 Historical Events displayed in UI
    var randomEvent1 = HistoricalMoment(event: "", year: 0)
    var randomEvent2 = HistoricalMoment(event: "", year: 0)
    var randomEvent3 = HistoricalMoment(event: "", year: 0)
    var randomEvent4 = HistoricalMoment(event: "", year: 0)
    
    let successImage = UIImage(named: "next_round_success")
    let failImage = UIImage(named: "next_round_fail")
    var alertHasShown = false
    var newGame = false
    
    // Timer Properties
    var timer = Timer()
    var counter: TimeInterval = 60
    var timeLeft = 60
    var timerRunning = false
    
    // Sound Properties
    var correctSound: SystemSoundID = 0
    var incorrectSound: SystemSoundID = 1

    
    
    // Collect the data from the plist and store it in an array
    required init?(coder aDecoder: NSCoder) {
        do {
            let array = try PlistConverter.arrayFromFile(resource: "HistoricalEvents", ofType: "plist")
            self.listOfInventions = PlistUnarchiver.createListFromArray(array: array)
            self.copyOfListOfInventions = PlistUnarchiver.createListFromArray(array: array)
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    
}
