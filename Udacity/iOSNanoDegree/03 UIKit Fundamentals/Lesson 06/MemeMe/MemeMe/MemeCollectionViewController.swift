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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var loadTestData = false
    
    override func viewDidLoad() {
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem (
            title: "+",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "addAMeme")
        if loadTestData{
            loadTestData = false
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!)) 
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(myMemeModel(topText: "thetop string", bottomText: "the bottom", image: UIImage(named: "testData")!, memedImage: UIImage(named: "testData")!))
        }
        collectionView?.reloadData()
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
        self.navigationController!.presentViewController(memeMakerViewController, animated: true, completion: nil)
    }
    
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewMemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        
        // Set the name and image
        cell.memeText.text = "\(meme.topText) \(meme.bottomText)"
        cell.memeImage.image = meme.image
        //cell.schemeLabel.text = "Scheme: \(villain.evilScheme)"
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let memeDetailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.selectedMemeIndex = indexPath.row
        self.navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
}