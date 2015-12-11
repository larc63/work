//
//  tappableLabel.swift
//  OnTheMap
//
//  Created by Luis Antonio Rodriguez on 12/11/15.
//  Copyright © 2015 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class tappableLabel:UILabel, UIGestureRecognizerDelegate{
    var url:String?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.themeBorderedButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.themeBorderedButton()
    }
    
    func themeBorderedButton() -> Void {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "labelAction:")
        addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    func labelAction(gr:UITapGestureRecognizer) {
        let app = UIApplication.sharedApplication()
        if let toOpen = url {
            app.openURL(NSURL(string: toOpen)!)
        }
    }
}