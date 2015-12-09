//
//  EnterURLViewController.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 12/8/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class EnterURLViewController: UIViewController, UITextViewDelegate{
    var long:Double = 0, lat:Double = 0, radius:Double = 0
    @IBOutlet weak var urlText: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    //MARK: text view delegate overrides
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    
    @IBAction func submitButtonTapped(sender: AnyObject) {
        guard NSURL(string: urlText.text) != nil else {
            print("URL was invalid")
            return
        }
        
    }
}