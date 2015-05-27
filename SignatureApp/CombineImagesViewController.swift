//
//  CombineImagesViewController.swift
//  SignatureApp
//
//  Created by Ryan Chee on 5/22/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class CombineImagesViewController: UIViewController {

    var photo: UIImage?
    var signatures: [Signature] = []
    var signatureUsed: UIImage?
    var albumName: String?
    
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformScale(view.transform,
                recognizer.scale, recognizer.scale)
            recognizer.scale = 1
        }
    }
    
    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = CGAffineTransformRotate(view.transform, recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    
    @IBAction func saveImages(sender: AnyObject) {
        println("done clicked")
        
        mergeImages(signatureView.image!,bottomImage: photoView.image!)
    }

    @IBOutlet weak var signatureView: UIImageView!
    @IBOutlet weak var photoView: UIImageView!
    @IBAction func pickSignature(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Choose a signature", message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            println("cancelled")
        }
        alertController.addAction(cancelAction)
        for (var i = 0; i < signatures.count; i++) {
            alertController.addAction(UIAlertAction(title: signatures[i].signatureName!, style: .Default, handler: { [unowned self] (alert :UIAlertAction!) -> Void in
           // UIAlertAction(title: signatures[i].signatureName!, style: .Default) { [unowned self] (_) in
                println("\(alert.title)")
                var index = self.returnSignature(alert.title)
                if index != -1 && index < self.signatures.count {
                    self.signatureUsed = self.signatures[index].signatureImage!
                    self.signatureView.image = self.signatureUsed
                    //edit signature size here?
                   // self.mergeImages(self.signatureUsed!, bottomImage: self.photo!)
                }
            }))
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func returnSignature(signatureName: String) -> Int {
        for (var i = 0; i < signatures.count; i++) {
            if signatureName == signatures[i].signatureName! {
                return i
            }
        }
        return -1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoView.image = self.photo!
        populateSignatures()
//        self.initializeGestureRecognizer()
        println("this many signatures: \(signatures.count)")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mergeImages(topImage: UIImage, bottomImage: UIImage) {
//        var width = bottomImage.size.width
//        var height = bottomImage.size.height
//        var newSize = CGSizeMake(width, height)
//        
//        UIGraphicsBeginImageContext(newSize)
//        bottomImage.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
//        topImage.drawAtPoint(CGPointMake(self.signatureView.frame.origin.x, self.signatureView.frame.origin.y), blendMode: kCGBlendModeNormal, alpha: 1)
//    //    topImage.drawInRect(CGRectMake(self.signatureView.frame.origin.x, self.signatureView.frame.origin.y, width, height), blendMode: kCGBlendModeNormal, alpha: 1)
//        var newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        //send this to parse db
//        var imageData = UIImagePNGRepresentation(newImage)
//        //save new image here to phone/ parse databse
//        
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
//        photoView.image = newImage
        var imageData = UIImagePNGRepresentation(newImage)
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
        let imageFile = PFFile(name:"image.png", data: imageData)
        
        var userPhoto = PFObject(className:"UserPhoto")
        userPhoto["Name"] = PFUser.currentUser()!.username
        userPhoto["AlbumName"] = self.albumName
        userPhoto["Picture"] = imageFile
        userPhoto.saveInBackgroundWithTarget(nil, selector: nil)
        println("done merging")
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func saveImage(newImage: UIImage) {
        println("use parse to save the new combined image")
    }

    func populateSignatures() {
        var currentUser = PFUser.currentUser()!.username
        var query = PFQuery(className:"Signatures")
        query.whereKey("username", equalTo:currentUser!)
        query.findObjectsInBackgroundWithBlock { [unowned self] (objects:[AnyObject]?, error:NSError?) -> Void in
            let objects = objects as! [PFObject]
            println("we have \(objects.count) objects)")
            for object in objects {
                let userImageFile = object["signature"] as! PFFile
                let signatureName = object["signatureName"] as! String
                userImageFile.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        let signatureToAdd = Signature(signature: UIImage(data:imageData!)!, signatureName: signatureName)
                        self.signatures.append(signatureToAdd)
                    }
                })
            }
        }
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
