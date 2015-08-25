//
//  ZipcodeTextFieldDelegate.swift
//  TextFields
//
//  Created by Luis Antonio Rodriguez on 8/24/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit

class ZipcodeTextFieldDelegate : NSObject, UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //TODO: ask if current text can be converted to a number and if the size is under 5
        println("Textfield = \(textField.text) would add \(string)")
        if let _char = string.cStringUsingEncoding(NSUTF8StringEncoding){
            let isBackSpace = strcmp(_char, "\\b")
            if isBackSpace  == -92 {
                println("pressed back space")
                return true
            }
        }
        if count(textField.text) > 4{
            return false
        }
        let c: Character = string[string.startIndex]
        if c >= "0" && c <= "9"{
            return true
        }else{
            return false
        }
    }
}
