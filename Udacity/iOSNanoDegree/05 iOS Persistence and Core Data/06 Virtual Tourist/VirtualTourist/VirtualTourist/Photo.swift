//
//  Photo.swift
//  VirtualTourist
//
//  Created by Luis Antonio Rodriguez on 1/31/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class Photo{
    var title:String?
    var id:String?
    
    var thumbnailURL: String?
    
    var image: UIImage? {
        get {
            return ImageCache.sharedInstance().imageWithIdentifier(id)
        }
        set {
            ImageCache.sharedInstance().storeImage(image, withIdentifier: id!)
        }
    }
}