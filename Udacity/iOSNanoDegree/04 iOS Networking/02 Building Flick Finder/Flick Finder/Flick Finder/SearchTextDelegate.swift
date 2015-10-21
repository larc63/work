//
//  SearchTextDelegate.swift
//  Flick Finder
//
//  Created by Luis Antonio Rodriguez on 10/12/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class SearchTextDelegate: NSObject, UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
