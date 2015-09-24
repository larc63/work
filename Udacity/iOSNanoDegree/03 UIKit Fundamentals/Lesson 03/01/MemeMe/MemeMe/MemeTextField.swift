//
//  MemeTextField.swift
//  MemeMe
//
//  Created by Luis Antonio Rodriguez on 9/24/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class MemeTextField: UITextField{
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    func initialize(){
        // Create a dictionary with the text attributes to use on the text fields
        let memeTextAttributes = [
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : CGFloat(-3.0),
            NSStrokeColorAttributeName : UIColor.blackColor()
        ]
        
        // set up the top text field
        delegate = memeTextFieldDelegate
        defaultTextAttributes = memeTextAttributes
        textAlignment = NSTextAlignment.Center
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
}