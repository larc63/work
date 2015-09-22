//
//  VillainDetailsController.swift
//  BondVillains
//
//  Created by Luis Antonio Rodriguez on 9/22/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit

class VillainDetailsController: UIViewController{
    
    @IBOutlet weak var theText: UILabel!
    @IBOutlet weak var theImage: UIImageView!
    var villain:Villain?
    override func viewWillAppear(animated: Bool) {
        theText.text = villain!.name
        theImage.image = UIImage(named: villain!.imageName)
        
    }
}