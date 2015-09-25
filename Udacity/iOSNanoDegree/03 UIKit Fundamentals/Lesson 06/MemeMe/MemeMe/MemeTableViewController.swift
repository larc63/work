//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Luis Antonio Rodriguez on 9/23/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate{
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        tableView.reloadData()
        navigationItem.rightBarButtonItem = UIBarButtonItem (
            title: "+",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "addAMeme")
    }
    
    // MARK: Navigation Controller related
    func addAMeme() {
        let memeMakerViewController = storyboard!.instantiateViewControllerWithIdentifier("MemeGeneratorViewController") as! MemeGeneratorViewController
        navigationController!.presentViewController(memeMakerViewController, animated: true, completion: nil)
    }
    
    // MARK: table data source methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableViewMemeCell") as! UITableViewCell
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        
        // Set the name and image
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        cell.imageView?.image = meme.image
        
        return cell
    }

    //MARK: Table delegat methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailViewController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.selectedMemeIndex = indexPath.row
        navigationController!.pushViewController(memeDetailViewController, animated: true)
        
    }
}