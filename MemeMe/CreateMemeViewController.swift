//
//  ViewController.swift
//  MemeMe
//
//  Created by Kyle Mills on 8/14/15.
//  Copyright (c) 2015 Kyle Mills Dev. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var memedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.enabled = false
        
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.placeholder = "TOP"
        
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.placeholder = "BOTTOM"
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shareMemedImage(sender: AnyObject) {
        memedImage = generateMemedImage()
        var activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if completed {
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Text Attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4
    ]
    
    //MARK: TextField Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        return true
    }
    
    //MARK: Moving the textFields up and down
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    //MARK: Save the memed Image
    func save() {
        let meme = MemeMe(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imagePickerView.image, memedImage: memedImage)
        
        //add is to the appDelegate Array
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //MARK: Generate the memedImage
    func generateMemedImage() -> UIImage {
        
        navBar.hidden = true
        toolBar.hidden = true
        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    //Cancel Button
    @IBAction func cancelButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

