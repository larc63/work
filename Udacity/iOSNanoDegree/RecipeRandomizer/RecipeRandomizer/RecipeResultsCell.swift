//
//  RecipeResultsCell.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 2/19/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class RecipeResultsCell : UICollectionViewCell{
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    // used for when using a placeholder image while downloading the recipe images
    var taskToCancelifCellIsReused: NSURLSessionTask? {
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
}