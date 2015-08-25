//
//  SwitchableTextFieldDelegate.swift
//  TextFields
//
//  Created by Luis Antonio Rodriguez on 8/24/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation
import UIKit

class SwitchableTextFieldDelegate: NSObject, UITextFieldDelegate{
    var isLocked = false
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return !isLocked
    }

}