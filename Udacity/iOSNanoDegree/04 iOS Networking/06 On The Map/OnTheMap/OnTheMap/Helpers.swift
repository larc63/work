//
//  Helpers.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 12/10/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation

class Helpers{
//    static let urlMatchRegex = "/^(https?:\\/\\/)?([a-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$/"
    static let urlMatchRegex = "^(https?:\\/\\/)?((([a-z0-9]+[a-z0-9\\.-]*)*[a-z0-9])+\\.)+((([a-z0-9]+[a-z0-9\\.-]*)*[a-z0-9])+)+\\/?"
    
    class func isValidURL(string: String) -> Bool{
        let range = string.rangeOfString(urlMatchRegex, options: .RegularExpressionSearch)
        return range != nil
    }
}