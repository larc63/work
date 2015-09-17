//
//  ViewController.swift
//  MemeMe
//
//  Created by Luis Antonio Rodriguez on 9/1/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var theToolbar: UIToolbar!
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    var hasClearedTop = false, hasClearedBottom = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let memeTextAttributes = [
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : CGFloat(-3.0),
            NSStrokeColorAttributeName : UIColor.blackColor()
        ]
        
        topText.delegate = self
        topText.text = "TOP"
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        bottomText.delegate = self
        bottomText.text = "BOTTOM"
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.Center
        
        shareButton.enabled = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateMemedImage() -> UIImage
    {
        theToolbar.hidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        theToolbar.hidden = false
        return memedImage
    }
    
    func save() {
        //Create the meme
        if let image = theImage.image{
            let meme = myMemeModel(top: topText.text, bottom:bottomText.text, image: image)
        }
    }
    
    @IBAction func shareTheMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        nextController.completionWithItemsHandler = { activity, success, items, error in
                self.save()
        }
        self.presentViewController(nextController, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "BOTTOM" && !hasClearedBottom{
            hasClearedBottom = true
            textField.text = ""
        }
        if textField.text == "TOP" && !hasClearedTop{
            hasClearedTop = true
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification){
        if bottomText.isFirstResponder(){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if bottomText.isFirstResponder(){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }

    @IBAction func pickActionPressed(sender: UIBarButtonItem) {
        let nextController = UIImagePickerController()
        nextController.delegate = self;
        nextController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(nextController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        let nextController = UIImagePickerController()
        nextController.delegate = self
        nextController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(nextController, animated: true, completion: nil)
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let anImage = image{
            theImage.image = anImage
            shareButton.enabled = true
        }else{
            println("something bad happened when the image was picked");
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

