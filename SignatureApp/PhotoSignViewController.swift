//
//  PhotoSignViewController.swift
//  SignatureApp
//
//  Created by Ryan Chee on 5/6/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class PhotoSignViewController: UIViewController {
    var photo: UIImage?
    var albumName: String?
    var signatureNameField: UITextField?
    var signatureName: String?

    @IBOutlet var photoSignView: PhotoSign?

    @IBAction func signatureName(sender: AnyObject) {
          }
//    @IBAction func scaleImage(sender: UIPinchGestureRecognizer) {
//        self.view.transform = CGAffineTransformScale(self.view.transform, sender.scale, sender.scale)
//        sender.scale = 1
//    }
    @IBAction func clearTapped() {
        println("Clear button tapped")
        photoSignView?.lines = []
        photoSignView?.setNeedsDisplay()
        photoSignView?.signed = false
    }

    
    @IBAction func colorTapped(button: UIButton!) {
        var color : UIColor!
        if (button.titleLabel?.text == "Black") {
            if photoSignView?.rainbowButton == true{
                photoSignView?.rainbowButton = false
            }
            println("black color tapped")
            color = UIColor.blackColor()
        }
        else if (button.titleLabel?.text == "Random") {
            if photoSignView?.rainbowButton == true{
                photoSignView?.rainbowButton = false
            }
            println("random color tapped")
            color = getRandomColor()
        }
        photoSignView?.drawColor = color

    }
    
    @IBAction func rainbowTapped() {
        if photoSignView?.rainbowButton == false {
        photoSignView?.rainbowButton = true
        }
        else {
        photoSignView?.rainbowButton = false;
        }
    }
    
    @IBAction func doneTapped() {
        println("done tapped")
        //add signature to parse database
 //       if let signed = photoSignView?.isSigned() {
            if photoSignView?.signed == true {
                let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Enter Signature Name:", preferredStyle: .Alert)
                
                //Create and add the Cancel action
                let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { [unowned self] action -> Void in
                    //Do some stuff
                }
                actionSheetController.addAction(cancelAction)
                //Create and an option action
                let nextAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { [unowned self] action -> Void in
                    if self.signatureNameField?.text != nil {
                        self.signatureName = self.signatureNameField!.text
                        println(self.signatureName)
                    }
                    
                    var signature = PFObject(className:"Signatures")
                    //                var signature = PFObject(className: "UserPhoto")
                    //                signature["Name"] = PFUser.currentUser()!.username
                    signature["username"] = PFUser.currentUser()!.username
                    UIGraphicsBeginImageContext(self.photoSignView!.frame.size)
                    self.photoSignView!.drawViewHierarchyInRect(self.photoSignView!.bounds, afterScreenUpdates: true)
                    
                    var signatureSaved = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    let imageData = UIImagePNGRepresentation(signatureSaved)
                    let imageFile = PFFile(name:"image.png", data: imageData)
                    //signatures in parse
                    signature["signature"] = imageFile
                    signature["signatureName"] = self.signatureName
                    signature.saveInBackgroundWithTarget(nil, selector: nil)
                    self.navigationController!.popViewControllerAnimated(true)
                    println("done signature")
                    
                }
                actionSheetController.addAction(nextAction)
                //Add a text field
                actionSheetController.addTextFieldWithConfigurationHandler { [unowned self]     textField -> Void in
                    //TextField configuration
                    textField.textColor = UIColor.blackColor()
                    self.signatureNameField = textField
                }
                
                //Present the AlertController
                self.presentViewController(actionSheetController, animated: true, completion: nil)
            }
//        }
        else {
            let actionSheetController: UIAlertController = UIAlertController(title: "Error", message: "No signature.", preferredStyle: .Alert)
            
            //Create and an option action
            let nextAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            }
            actionSheetController.addAction(nextAction)
//            //Add a text field
//            actionSheetController.addTextFieldWithConfigurationHandler { textField -> Void in
//                //TextField configuration
//                textField.textColor = UIColor.blackColor()
//            }
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)

        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        photoSignView!.image = photo
//        photoSignView?.contentMode = .ScaleAspectFit
//        photoSignView!.backgroundColor = UIColor(patternImage: photo!.imageWithAlignmentRectInsets(UIEdgeInsets(top:10,left:0,bottom:10,right:0)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRandomColor() -> UIColor {
        var randomRed: CGFloat = CGFloat(drand48())
        var randomGreen: CGFloat = CGFloat(drand48())
        var randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }



}
