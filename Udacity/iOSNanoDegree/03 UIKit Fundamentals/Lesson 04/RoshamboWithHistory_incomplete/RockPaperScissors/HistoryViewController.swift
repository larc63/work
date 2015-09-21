//
//  HistoryViewController.swift
//  RockPaperScissors
//
//  Created by Luis Antonio Rodriguez on 9/20/15.
//  Copyright (c) 2015 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    var history: [RPSMatch]!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let history = self.history{
            return history.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RSBHistory") as! UITableViewCell
        let element = self.history![indexPath.row]
        cell.textLabel?.text = victoryStatusDescription(element)
        if let label = cell.detailTextLabel{
            label.text = "\(element.p1) vs. \(element.p2)"
        }
        return cell
    }
    
    func victoryStatusDescription(match: RPSMatch) -> String {
        
        if (match.p1 == match.p2) {
            return "Tie."
        } else if (match.p1.defeats(match.p2)) {
            return "Win!"
        } else {
            return "Loss."
        }
    }
    @IBAction func dismissView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}