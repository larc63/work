//
//  ViewController.swift
//  Roshambo
//
//  Created by Luis Antonio Rodriguez on 8/22/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var tempResult: (RoshamboResults, String)?
    func getMatchResult(userPlay:RoshamboPlays) -> (RoshamboResults, String){
        // Generate a random Int32 using arc4Random
        var result = RoshamboResults.itsATie
        var message = "It's a tie!"
        let computerPlay = RoshamboPlays(rawValue: Int(1 + arc4random() % 3))!
        println("computer plays \(computerPlay.rawValue)")
        switch (userPlay){
        case .ROCK:
            switch (computerPlay){
            case .ROCK:
                result = RoshamboResults.itsATie
                message = "It's a tie!"
                break
            case .PAPER:
                result = RoshamboResults.paperCoversRock
                message = "Computer wins!"
                break
            case .SCISSORS:
                result = RoshamboResults.rockCrushesScissors
                message = "You win!"
                break
            }
            break
        case .SCISSORS:
            switch (computerPlay){
            case .ROCK:
                result = RoshamboResults.rockCrushesScissors
                message = "Computer wins!"
                break
            case .PAPER:
                result = RoshamboResults.scissorsCutPaper
                message = "You win!"
                break
            case .SCISSORS:
                result = RoshamboResults.itsATie
                message = "It's a tie!"
                break
            }
            break
        case .PAPER:
            switch (computerPlay){
            case .ROCK:
                result = RoshamboResults.paperCoversRock
                message = "You win!"
                break
            case .PAPER:
                result = RoshamboResults.itsATie
                message = "It's a tie!"
                break
            case .SCISSORS:
                result = RoshamboResults.scissorsCutPaper
                message = "Computer wins!"
                break
            }
            break
        }
        return (result, message)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func pressedRock(sender: UIButton) {
        var controller: MatchResultController
        
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("matchResult") as! MatchResultController
        controller.result = self.getMatchResult(RoshamboPlays.ROCK);
        
        // Present the view Controller
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func pressedPaper(sender: UIButton) {
        tempResult = self.getMatchResult(RoshamboPlays.PAPER)
        self.performSegueWithIdentifier("getResult", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("segue=\(segue.identifier)")
        if segue.identifier == "getResult"{
            let controller = segue.destinationViewController as! MatchResultController
            if let myResult = self.tempResult{
                controller.result = myResult
            } else {
                controller.result = self.getMatchResult(RoshamboPlays.SCISSORS);
            }
        }
    }
}

