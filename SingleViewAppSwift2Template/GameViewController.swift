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
import SafariServices


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
    var
    = HistoricalMoment(event: "", year: 0)
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
    
    //Linked Connections
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view1DownButton: UIButton!
    @IBOutlet weak var view2UpButton: UIButton!
    @IBOutlet weak var view2DownButton: UIButton!
    @IBOutlet weak var view3UpButton: UIButton!
    @IBOutlet weak var view3DownButton: UIButton!
    @IBOutlet weak var view4UpButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var eventListed1: UIButton!
    @IBOutlet weak var eventListed2: UIButton!
    @IBOutlet weak var eventListed3: UIButton!
    @IBOutlet weak var eventListed4: UIButton!


    
    
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
    
    // Pre-load game Sounds/Set up UI
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCorrectSound()
        loadIncorrectSound()
        setupAppUI()
    }
    
    // When the view pops up
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // Show the alert and reset the timer
        showAlert()
        resetTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Connect the score mechanics between the two segues
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gameOver" {
            if let controller = segue.destination as? GameOverViewController {
                controller.roundsCorrect = self.roundsCorrect
                controller.roundsPlayed = self.roundsPlayed
            }
        }
    }
    
    // Enable portrait mode only.
     func shouldAutorotate() -> Bool {
        return false
    }
    
     func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    // Hide status bar
     func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Enable app for motion detection
     func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // Check answer when device is shaken
     func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .motionShake {
            checkAnswer()
        }
    }
    
    // Buttons to swap events
    @IBAction func View1Down(sender: UIButton) {
        swapInventions(&setOfInventions[0], secondInvention: &setOfInventions[1])
    }
    @IBAction func View2Up(sender: UIButton) {
        swapInventions(&setOfInventions[1], secondInvention: &setOfInventions[0])
    }
    @IBAction func View2Down(sender: UIButton) {
        swapInventions(&setOfInventions[1], secondInvention: &setOfInventions[2])
    }
    @IBAction func View3Up(sender: UIButton) {
        swapInventions(&setOfInventions[2], secondInvention: &setOfInventions[1])
    }
    @IBAction func View3Down(sender: UIButton) {
        swapInventions(&setOfInventions[2], secondInvention: &setOfInventions[3])
    }
    @IBAction func View4Up(sender: UIButton) {
        swapInventions(&setOfInventions[3], secondInvention: &setOfInventions[2])
    }
    
    // Next round button
    @IBAction func PlayNextRound(sender: AnyObject) {
        // Get new list of inventions, reset and start the timer, and display the list of inventions
        breakSetOfInventions()
        getListOfInventions()
        displaySetOfInventions()
        self.timerLabel.setBackgroundImage(nil, forState: .Normal)
    }
    
    // When a round is over, click on an invention to pull up a Wikipedia page with SafariViewController
    @IBAction func Invention1URL(sender: UIButton) {
        let sfViewController = SFSafariViewController(URL: NSURL(string: setOfInventions[0].url)!, entersReaderIfAvailable: true)
        self.presentViewController(sfViewController, animated: true, completion: nil)
    }
    @IBAction func Invention2URL(sender: UIButton) {
        let sfViewController = SFSafariViewController(URL: NSURL(string: setOfInventions[1].url)!, entersReaderIfAvailable: true)
        self.presentViewController(sfViewController, animated: true, completion: nil)
    }
    @IBAction func Invention3URL(sender: UIButton) {
        let sfViewController = SFSafariViewController(URL: NSURL(string: setOfInventions[2].url)!, entersReaderIfAvailable: true)
        self.presentViewController(sfViewController, animated: true, completion: nil)
    }
    @IBAction func Invention4URL(sender: UIButton) {
        let sfViewController = SFSafariViewController(URL: NSURL(string: setOfInventions[3].url)!, entersReaderIfAvailable: true)
        self.presentViewController(sfViewController, animated: true, completion: nil)
    }
    
    // Round edges and reset text box in each invention view
    func setupAppUI() {
        view1.layer.cornerRadius = 5
        view2.layer.cornerRadius = 5
        view3.layer.cornerRadius = 5
        view4.layer.cornerRadius = 5
        
        eventListed1.setTitle(nil, for: .normal)
        eventListed2.setTitle(nil, for: .normal)
        eventListed3.setTitle(nil, for: .normal)
        eventListed4.setTitle(nil, for: .normal)
    }
    
    // Get a random set of inventions. This function runs once every round.
    func getListOfInventions() {
        var randomIndex1: Int
        var randomIndex2: Int
        var randomIndex3: Int
        var randomIndex4: Int
        
        // Get a random number, assign the first random invention with the listOfInventions[randomIndex], and repeat the process with every random invention
        randomIndex1 = GKRandomSource.sharedRandom().nextIntWithUpperBound(listOfInventions.count)
        randomEvent1 = listOfInventions[randomIndex1]
        listOfInventions.remove(at: randomIndex1)
        randomIndex2 = GKRandomSource.sharedRandom().nextIntWithUpperBound(listOfInventions.count)
        randomEvent2 = listOfInventions[randomIndex2]
        listOfInventions.remove(at: randomIndex2)
        randomIndex3 = GKRandomSource.sharedRandom().nextIntWithUpperBound(listOfInventions.count)
        randomEvent3 = listOfInventions[randomIndex3]
        listOfInventions.remove(at: randomIndex3)
        randomIndex4 = GKRandomSource.sharedRandom().nextIntWithUpperBound(listOfInventions.count)
        randomEvent4 = listOfInventions[randomIndex4]
        listOfInventions.remove(at: randomIndex4)
        
        // If the game is over...
        if roundsPlayed == 6 {
            // Show your score in a new controller and reset the game data
            presentGameOverController()
            roundsPlayed = 0
            roundsCorrect = 0
            // Else if the game hasn't started
        } else if roundsPlayed == 0 {
            // Refresh the list of inventions
            listOfInventions = copyOfListOfInventions
        }
        
        // Create two arrays, one with the inventions and one with the inventions in order.
        setOfInventions.append(randomEvent1); setOfInventions.append(randomEvent2); setOfInventions.append(randomEvent3); setOfInventions.append(randomEvent4)
        setOfInventionsInOrder.append(randomEvent1); setOfInventionsInOrder.append(randomEvent2); setOfInventionsInOrder.append(randomEvent3); setOfInventionsInOrder.append(randomEvent4)
        setOfInventionsInOrder.sortInPlace({$0.year < $1.year})
        
        // Prepare the round for use
        resetTimer()
        beginTimer()
        timerLabel.setTitle("0:\(timeLeft)", forState: .Normal)
        InformationLabel.text = "Shake to Complete"
        disableURLEvents()
        enableSwapButtons()
        hideNextRoundButtons()
    }
    
    // Show the inventions in the views
    func displaySetOfInventions() {
        eventListed1.setTitle(setOfInventions[0].event, for: .normal)
        eventListed2.setTitle(setOfInventions[1].event, for: .normal)
        eventListed3.setTitle(setOfInventions[2].event, for: .normal)
        eventListed4.setTitle(setOfInventions[3].event, for: .normal)
    }
    
    // Take two inventions and swap their order in the setOfInventions array
    func swapInventions( firstInvention: inout Invention, secondInvention: inout Invention) {
        let tempFirstInvention = firstInvention
        firstInvention = secondInvention
        secondInvention = tempFirstInvention
        // Update the display
        displaySetOfInventions()
    }
    
    // Check the answer
    func checkAnswer() {
        // Set up game for answer viewing
        timer.invalidate()
        timerLabel.isEnabled = true
        timerLabel.setTitle("", forState: .Normal)
        roundsPlayed += 1
        timerLabel.isEnabled = true
        enableURLEvents()
        disableSwapButtons()
        
        // If the order of the inventions in the two arrays are identical (the answer is correct)...
        if setOfInventions[0].event == setOfInventionsInOrder[0].event && setOfInventions[1].event == setOfInventionsInOrder[1].event && setOfInventions[2].event == setOfInventionsInOrder[2].event && setOfInventions[3].event == setOfInventionsInOrder[3].event {
            // Show the user they got the answer correct
            self.InformationLabel.text = "Tap an event to learn more"
            self.roundsCorrect += 1
            self.playCorrectSound()
            self.timerLabel.setBackgroundImage(successImage, forState: .Normal)
        } else {
            // Show the user they got the answer incorrect
            self.InformationLabel.text = "Tap an event to learn more"
            self.playIncorrectSound()
            self.timerLabel.setBackgroundImage(failImage, forState: .Normal)
        }
    }
    
    // Create a new alert that gives the player instructions on how to play the game. This function will only be called when the game loads.
    func showAlert() {
        if alertHasShown == false {
            alertHasShown = true
            let alertController = UIAlertController(title: "Welcome to Bout Time!", message: "In this game, you are given a list of inventions which you have to sort by the order of the invention, oldest on top. You have 6 rounds.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: dismissAlert)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // Show the player their score in a new view controller
    func presentGameOverController() {
        self.performSegueWithIdentifier("gameOver", sender: self)
    }
    
    // Begin the game when the user taps "OK" on the alert
    func dismissAlert(sender: UIAlertAction) {
        getListOfInventions()
        displaySetOfInventions()
    }
    
    // MARK: Helper methods
    
    // Allow the player to view the inventions in a web browser
    func enableURLEvents() {
        eventListed1.isEnabled = true
        eventListed2.isEnabled = true
        eventListed3.isEnabled = true
        eventListed4.isEnabled = true
    }
    
    // Don't allow the player to view the inventions in a web browser
    func disableURLEvents() {
        eventListed1.isEnabled = false
        eventListed2.isEnabled = false
        eventListed3.isEnabled = false
        eventListed4.isEnabled = false
    }
    
    // Allow the player to swap the inventions
    func enableSwapButtons() {
        view1DownButton.isEnabled = true
        view2UpButton.isEnabled = true
        view2DownButton.isEnabled = true
        view3UpButton.isEnabled = true
        view3DownButton.isEnabled = true
        view4UpButton.isEnabled = true
    }
    
    // Don't allow the player to swap the inventions
    func disableSwapButtons() {
        view1DownButton.isEnabled = false
        view2UpButton.isEnabled = false
        view2DownButton.isEnabled = false
        view3UpButton.isEnabled = false
        view3DownButton.isEnabled = false
        view4UpButton.isEnabled = false
    }
    
    // Show the normal timer
    func hideNextRoundButtons() {
        timerLabel.setImage(nil, forState: .Normal)
        timerLabel.isHidden = false
        timerLabel.isEnabled = false
    }
    
    // Start the timer
    func beginTimer() {
        if timerRunning == false {
            counter = 60
            timeLeft = 60
            timerRunning = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    // Update the timer every second
    func updateTimer() {
        timeLeft -= 1
        timerLabel.setTitle("0:\(timeLeft)", forState: .Normal)
        
        // If the timer runs out of time
        if timeLeft == 0 {
            // Stop the timer and check the answer
            timer.invalidate()
            checkAnswer()
            timerLabel.setTitle("", forState: .Normal)
        }
        
        // Make the timer look regular with one digit of time left
        if timeLeft <= 9 && timeLeft >= 1 {
            timerLabel.setTitle("0:0\(timeLeft)", forState: .Normal)
        }
    }
    
    // Reset the timer's properties
    func resetTimer() {
        timeLeft = 60
        counter = 60
        timerRunning = false
    }
    
    // Break the set of Inventions
    func breakSetOfInventions() {
        setOfInventions.removeAll()
        setOfInventionsInOrder.removeAll()
    }
    
    // Load both the correct and incorrect sounds for the game. Also create functions to play the sounds.
    
    func loadCorrectSound() {
        let pathToSoundFile = Bundle.mainBundle().pathForResource("CorrectDing", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &correctSound)
    }
    
    func playCorrectSound() {
        AudioServicesPlaySystemSound(correctSound)
    }
    
    func loadIncorrectSound() {
        let pathToSoundFile = Bundle.mainBundle().pathForResource("IncorrectBuzz", ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &incorrectSound)
    }
    
    func playIncorrectSound() {
        AudioServicesPlaySystemSound(incorrectSound)
    }
    


    
  
    
    
}
