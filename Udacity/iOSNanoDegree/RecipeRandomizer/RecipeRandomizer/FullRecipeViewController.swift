//
//  FullRecipeViewController.swift
//  RecipeRandomizer
//
//  Created by Luis Antonio Rodriguez on 2/20/16.
//  Copyright © 2016 Luis Antonio Rodriguez. All rights reserved.
//

import Foundation
import UIKit

class FullRecipeViewController : UIViewController{
    var requestURL: NSURLRequest?
    
    @IBOutlet weak var webView: UIWebView!
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        if requestURL != nil {
            self.webView.loadRequest(requestURL!)
        }
    }
}