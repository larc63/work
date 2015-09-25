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
    // MARK: View lifecycle methods
    override func viewDidLoad() {
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
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
        collectionView?.reloadData()
    }
    
    // MARK: Navigation button
    func addAMeme() {
        let memeMakerViewController = storyboard!.instantiateViewControllerWithIdentifier("MemeGeneratorViewController") as! MemeGeneratorViewController
        navigationController!.presentViewController(memeMakerViewController, animated: true, completion: nil)
    }
    
    
    // MARK: Collection View Related methods
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewMemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        
        // Set the text and image
        cell.memeText.text = "\(meme.topText) \(meme.bottomText)"
        cell.memeImage.image = meme.image
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let memeDetailViewController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        memeDetailViewController.selectedMemeIndex = indexPath.row
        navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
}