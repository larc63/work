//
//  ViewController.swift
//  MemeMe
//
//  Created by Luis Antonio Rodriguez on 9/1/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var hasClearedTop = false, hasClearedBottom = false
    // MARK: view controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Create a dictionary with the text attributes to use on the text fields
        let memeTextAttributes = [
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeWidthAttributeName : CGFloat(-3.0),
            NSStrokeColorAttributeName : UIColor.blackColor()
        ]
        // set up the top text field
        topText.delegate = self
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = NSTextAlignment.Center
        // set up the bottom text field
        bottomText.delegate = self
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = NSTextAlignment.Center

        reset()
        
        // Determine if the camera button should be enabled
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    // Subscribe to keyboard notifications here
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    // Unsubscribe to keyboard notifications here
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set up the view as a full screen app
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    // MARK: meme_model helper methods
    func generateMemedImage() -> UIImage
    {
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        bottomToolbar.hidden = false
        topToolbar.hidden = false
        return memedImage
    }
    
    //Create the meme, text fields can be empty, but the image cannot be nil
    func save() {
        if let image = theImage.image{
            let meme = myMemeModel(topText: topText.text, bottomText: bottomText.text, image: image, memedImage: generateMemedImage())
        }
    }
    // Put the helper variables and meme variables back to their default values
    func reset(){
        theImage.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        hasClearedTop = false
        hasClearedBottom = false
        cancelButton.enabled = false
        shareButton.enabled = false
    }
    
    // MARK: keyboard related methods
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
    // MARK: UITextFieldDelegate methods
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "BOTTOM" && !hasClearedBottom{
            hasClearedBottom = true
            textField.text = ""
        }
        if textField.text == "TOP" && !hasClearedTop{
            hasClearedTop = true
            textField.text = ""
        }
        cancelButton.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: Top toolbar handlers
    @IBAction func clearMeme(sender: AnyObject) {
        reset()
    }
    
    @IBAction func shareTheMeme(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let nextController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        nextController.completionWithItemsHandler = { activity, success, items, error in
            self.save()
        }
        self.presentViewController(nextController, animated: true, completion: nil)
    }
    
    // MARK: Bottom toolbar handlers
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
    
    // MARK: Image picker controller methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let anImage = image{
            theImage.image = anImage
            cancelButton.enabled = true
            shareButton.enabled = true
        }else{
            println("something bad happened when the image was picked");
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

