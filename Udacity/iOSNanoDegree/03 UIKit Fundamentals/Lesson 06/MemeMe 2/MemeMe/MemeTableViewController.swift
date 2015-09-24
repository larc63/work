//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Luis Antonio Rodriguez on 9/23/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var memes: [myMemeModel] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem (
            title: "+",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "addAMeme")
    }
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.memes = appDelegate.memes
        self.memes.append(myMemeModel(top: "thetop string", bottom: "the bottom", image: UIImage(named: "testData")!))
    }
    
    
    // MARK: Navigation button
    func addAMeme() {
        let memeMakerViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeMakerViewController") as! MemeMakerViewController
        //        memeMakerViewController = self.memes[indexPath.row]
        self.navigationController!.pushViewController(memeMakerViewController, animated: true)
    }
    
    // MARK: table data source and delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("VillainCell") as! UITableViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        cell.imageView?.image = meme.image
        
//        // If the cell has a detail label, we will put the evil scheme in.
//        if let detailTextLabel = cell.detailTextLabel {
//            detailTextLabel.text = "Scheme: \(villain.evilScheme)"
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let memeMakerViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeMakerViewController") as! MemeMakerViewController
//        memeMakerViewController.villain = self.allVillains[indexPath.row]
        self.navigationController!.pushViewController(memeMakerViewController, animated: true)
        
    }
}