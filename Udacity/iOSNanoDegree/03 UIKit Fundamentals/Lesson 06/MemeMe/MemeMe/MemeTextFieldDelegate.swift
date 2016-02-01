//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Luis Antonio Rodriguez on 9/24/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate : NSObject, UITextFieldDelegate{
    var hasBeenCleared = false
    var cancelButton: UIBarButtonItem!
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if !hasBeenCleared {
            hasBeenCleared = true
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        cancelButton.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}