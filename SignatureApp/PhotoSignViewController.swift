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
    
    @IBOutlet var photoSignView: PhotoSign?
    
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
                var signature = PFObject(className:"Signatures")
                signature["username"] = PFUser.currentUser()!.username
                UIGraphicsBeginImageContext(photoSignView!.frame.size)
                photoSignView!.drawViewHierarchyInRect(photoSignView!.bounds, afterScreenUpdates: true)
                
                var signatureSaved = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let imageData = UIImagePNGRepresentation(signatureSaved)
                let imageFile = PFFile(name:"image.png", data: imageData)
                signature["signature"] = imageFile
                signature["signatureName"] = "temp"
                signature.saveInBackgroundWithTarget(nil, selector: nil)
                println("ended here")
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
        photoSignView!.backgroundColor = UIColor(patternImage: photo!.imageWithAlignmentRectInsets(UIEdgeInsets(top:10,left:0,bottom:10,right:0)))
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
