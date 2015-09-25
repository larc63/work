//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Luis Antonio Rodriguez on 9/24/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController : UIViewController{
    var selectedMemeIndex: Int = 0
    @IBOutlet weak var theImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true

        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[selectedMemeIndex]
        theImage.image = meme.memedImage
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(selectedMemeIndex)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func editMeme(sender: AnyObject) {
    }
}