//
//  ViewControllerForKeyboard.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 12/14/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerForKeyboard:UIViewController{
    var tapRecognizer: UITapGestureRecognizer?
    var isKeyboardVisible:Bool = false
    var keyboardHeight:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    // Unsubscribe to keyboard notifications here
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let height = keyboardSize.CGRectValue().height
        return min(180, height)
    }

}