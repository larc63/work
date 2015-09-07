//
//  ViewController.swift
//  MemeMe
//
//  Created by Luis Antonio Rodriguez on 9/1/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    var hasClearedTop = false, hasClearedBottom = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.whiteColor(),
            NSForegroundColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : CGFloat(3.0)
        ]
        
        topText.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.delegate = self
        bottomText.defaultTextAttributes = memeTextAttributes
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "BOTTOM" && !hasClearedBottom{
            hasClearedBottom = true
            textField.text = "";
        }
        if textField.text == "TOP" && !hasClearedTop{
            hasClearedTop = true
            textField.text = "";
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    @IBAction func pickActionPressed(sender: UIBarButtonItem) {
        let nextController = UIImagePickerController()
        nextController.delegate = self;
        nextController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(nextController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        let nextController = UIImagePickerController()
        nextController.delegate = self;
        nextController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(nextController, animated: true, completion: nil)
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let anImage = image{
            theImage.image = anImage
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

