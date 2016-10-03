//
//  GameOverViewController.swift
//  SingleViewAppSwift2Template
//
//  Created by Nathanael Grant on 9/26/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    
    var roundsCorrect = 0
    var roundsPlayed = 0
    let totalRounds = 6
    


    override func viewDidLoad() {
        super.viewDidLoad()
        showScore()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBOutlet weak var gameOverScore: UILabel!
    
    
    func showScore() {
        gameOverScore.text = "\(roundsCorrect)/\(totalRounds)"
    }
    
    
    
    @IBAction func PlayAgain(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)

    }
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
