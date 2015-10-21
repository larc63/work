//
//  CurrencyTextFieldDelegat.swift
//  TextFields
//
//  Created by Luis Antonio Rodriguez on 8/24/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit

class CurrencyTextFieldDelegate : NSObject, UITextFieldDelegate {
    var localString = "000"
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //TODO: ask if current text can be converted to a number and if the size is under 5
        print("Textfield = \(textField.text) would add \(string)")
        23
        if string.characters.count > 0 {
            let c = string[string.startIndex]
            if c >= "0" && c <= "9"{
                var tempString = textField.text! + string
                if tempString[tempString.startIndex] == "$"{
                    let index = string.startIndex.advancedBy(1)
                    tempString = tempString.substringFromIndex(index)
                }
                let arr = tempString.componentsSeparatedByString(".")
                var integer: Int = Int(arr[0])!
                var decimals: Int = Int(arr[1])!
                integer *= 10
                integer += (decimals/100)
                decimals %= 100
                var leftPart = String(integer)
                var rightPart = String(decimals)
                if rightPart.characters.count < 2{
                    rightPart = "0" + rightPart
                }
                textField.text = "$" + leftPart + "." + rightPart
                return false
            }else{
                return false
        }
        }else{
            return false
        }
    }
}
