//
//  myMemeModel.swift
//  MemeMe
//
//  Created by Luis Antonio Rodriguez on 9/7/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit
class myMemeModel{
    var topText: String?
    var bottomText: String?
    var image: UIImage?
    
    
    init(top: String, bottom: String, image: UIImage){
        topText = top
        bottomText = bottom
        self.image = image
    }
}