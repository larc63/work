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
    
    func initWithTopText(topText: String, bottomText: String, image: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
    }
}