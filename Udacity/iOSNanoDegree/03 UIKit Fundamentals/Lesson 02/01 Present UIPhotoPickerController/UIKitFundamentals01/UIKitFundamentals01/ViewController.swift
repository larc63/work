//
//  ViewController.swift
//  UIKitFundamentals01
//
//  Created by Luis Antonio Rodriguez on 8/21/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func clicked(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}

