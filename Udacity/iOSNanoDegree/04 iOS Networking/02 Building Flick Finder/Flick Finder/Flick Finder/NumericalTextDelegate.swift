//
//  NumericalTextDelegate.swift
//  Flick Finder
//
//  Created by Luis Antonio Rodriguez on 10/12/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class NumericalTextDelegate: NSObject, UITextFieldDelegate{
    var maxLimit: Float
    var minLimit: Float
    
    override init(){
        self.maxLimit = 0
        self.minLimit = 0
    }
    
//    init(maxLimit: Float, minLimit: Float){
//        self.maxLimit = maxLimit
//        self.minLimit = minLimit
//    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("Textfield = \(textField.text) would add \(string)")
        return true
    }
    
//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        print("Textfield = \(textField.text) would add \(string)")
//        if string.characters.count > 0 {
//            let c = string[string.startIndex]
//            if (c >= "0" && c <= "9") || c == "."{
//                let tempString = textField.text! + string
//                let tempFloat: Float? = Float(tempString)!
//                if tempFloat > minLimit && tempFloat < maxLimit {
//                    textField.text = tempString
//                    return true
//                }
//            }
//        }
//        return false
//    }
}
