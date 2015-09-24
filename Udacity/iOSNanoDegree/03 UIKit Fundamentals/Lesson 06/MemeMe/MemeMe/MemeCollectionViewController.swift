//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Luis Antonio Rodriguez on 9/23/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController, UICollectionViewDataSource {
    var memes:[myMemeModel] = []
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem (
            title: "+",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "addAMeme")

        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.memes = appDelegate.memes
        self.memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
        self.memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
        self.memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
        self.memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
        self.memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
        self.memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
        self.memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
        self.memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
        self.memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
    }
    
    override func viewDidLoad() {
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    //MARK: rotation stuff
//    override func shouldAutorotate() -> Bool {
//        return true
//    }
//    
//    override func supportedInterfaceOrientations() -> Int {
//        return UIInterfaceOrientation.LandscapeLeft.rawValue | UIInterfaceOrientation.LandscapeRight.rawValue | UIInterfaceOrientation.PortraitUpsideDown.rawValue | UIInterfaceOrientation.Portrait.rawValue
//    }
//    
//    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
//        switch (toInterfaceOrientation){
//        case UIInterfaceOrientation.LandscapeLeft, UIInterfaceOrientation.LandscapeRight:
//            let space: CGFloat = 3.0
//            let dimension = (self.view.frame.size.height - (2 * space)) / 3.0
//            flowLayout.minimumInteritemSpacing = space
//            flowLayout.minimumLineSpacing = space
//            flowLayout.itemSize = CGSizeMake(dimension, dimension)
//            break;
//        case UIInterfaceOrientation.Portrait, UIInterfaceOrientation.PortraitUpsideDown:
//            let space: CGFloat = 3.0
//            let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
//            flowLayout.minimumInteritemSpacing = space
//            flowLayout.minimumLineSpacing = space
//            flowLayout.itemSize = CGSizeMake(dimension, dimension)
//            break;
//        default:
//            break;
//        }
//    }
    
    // MARK: Navigation button
    func addAMeme() {
        let memeMakerViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeGeneratorViewController") as! MemeGeneratorViewController
        //        memeMakerViewController = self.memes[indexPath.row]
        self.navigationController!.presentViewController(memeMakerViewController, animated: true, completion: nil)
    }
    
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewMemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        cell.memeText.text = "\(meme.topText) \(meme.bottomText)"
        cell.memeImage.image = meme.image
        //cell.schemeLabel.text = "Scheme: \(villain.evilScheme)"
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let memeMakerViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeGeneratorViewController") as! MemeGeneratorViewController
//        memeMakerViewController = self.memes[indexPath.row]
        self.navigationController!.pushViewController(memeMakerViewController, animated: true)
        
    }
}