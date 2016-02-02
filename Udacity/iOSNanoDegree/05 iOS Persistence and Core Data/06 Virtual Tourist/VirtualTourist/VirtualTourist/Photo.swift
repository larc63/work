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
    var imagePath:String?
    
    var thumbnailURL: String {
        get {
            return ""
        }
    }
    
    var image: UIImage? {
        get {
            return nil//TheMovieDB.Caches.imageCache.imageWithIdentifier(imagePath)
        }
        set {
//            TheMovieDB.Caches.imageCache.storeImage(image, withIdentifier: imagePath!)
        }
    }
}