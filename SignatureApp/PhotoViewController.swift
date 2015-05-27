//
//  PhotoViewController.swift
//  SignatureApp
//
//  Created by Ryan Chee on 2/24/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    let image = UIImagePickerController()
    let imageNum = 0;
    var iter = 0
    var photoLibraryImages: [UIImage] = []
    var imageSelected: UIImage?
    var albumName: String?
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        if let view = recognizer.view {
            if recognizer.state == UIGestureRecognizerState.Ended {
                println("in reload view")
                photoLibraryImages = []
                populateAlbum(self.albumName!)
                view.setNeedsDisplay()
            }
        }
    }
    
    @IBAction func addPhoto(sender: AnyObject) {
        let alertController = UIAlertController(title: "Choose photo from...", message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            println(action)
        }
        alertController.addAction(cancelAction)
        let oneAction = UIAlertAction(title: "Camera", style: .Default) { [unowned self] (_) in
            let picker = UIImagePickerController()
            picker.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                picker.sourceType = .Camera
            }
            else {
                picker.sourceType = .PhotoLibrary
            }
            self.presentViewController(picker, animated: true, completion: nil)
        }
        let twoAction = UIAlertAction(title: "Photo Album", style: .Default) { [unowned self] (_) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .PhotoLibrary
            picker.allowsEditing = false
            self.presentViewController(picker, animated: true, completion: nil)
        }
        
        let signatureAction = UIAlertAction(title: "Signature", style: .Default) { [unowned self] (_) in
            self.performSegueWithIdentifier("signature", sender: self)
        }

        alertController.addAction(oneAction)
        alertController.addAction(twoAction)
        alertController.addAction(signatureAction)
        self.presentViewController(alertController, animated: true, completion: nil)

    }

    @IBOutlet var collectionView :UICollectionView!
    
    @IBAction func cameraButton() {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            picker.sourceType = .Camera
        }
        else {
            picker.sourceType = .PhotoLibrary
        }
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func photoLibraryButton() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = false        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func unwindToPhotoViewController(segue: UIStoryboardSegue) {
        println("here!")
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        photoLibraryImages.append(chosenImage)
        dismissViewControllerAnimated(true, completion: nil) //5
        self.collectionView.reloadData()
        
        let imageData = UIImagePNGRepresentation(chosenImage)
        let imageFile = PFFile(name:"image.png", data: imageData)
        
        
        var userPhoto = PFObject(className:"UserPhoto")
        userPhoto["Name"] = PFUser.currentUser()!.username
        userPhoto["AlbumName"] = self.albumName
        userPhoto["Picture"] = imageFile
        userPhoto.saveInBackgroundWithTarget(nil, selector: nil)

    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        println("there are \(photoLibraryImages.count) images")
        return photoLibraryImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            var cell: PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
            cell.photoCell.image = photoLibraryImages[indexPath.row]
            iter++
            return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        println("PhotoViewCell \(indexPath.row) selected");
        let cell: PhotoCell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCell
    }
    
    func populateAlbum(albumName: String) {
        var currentUser = PFUser.currentUser()!.username
        var query = PFQuery(className:"UserPhoto")
        query.whereKey("Name", equalTo:currentUser!)
        query.whereKey("AlbumName", equalTo:albumName)
        query.findObjectsInBackgroundWithBlock ({(objects:[AnyObject]?, error: NSError?) in
            if(error == nil){
                
                let imageObjects = objects as! [PFObject]
                
                for object in imageObjects {
                    
                    let thumbNail = object["Picture"] as! PFFile
                    println("we got \(imageObjects.count) images!")
                    thumbNail.getDataInBackgroundWithBlock({
                        (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            let image = UIImage(data:imageData!)
                            //image object implementation
                            self.photoLibraryImages.append(image!)
                            self.collectionView.reloadData()
                        }
                        			
                    })//getDataInBackgroundWithBlock - end
                    
                }//for - end
               // self.collectionView.reloadData()
            }
            else{
                println("Error in retrieving \(error)")
            }
        })//findObjectsInBackgroundWithblock - end
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("should load\n");
        image.delegate = self
        populateAlbum(self.albumName!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "combineImages" {
            let dest = segue.destinationViewController as! CombineImagesViewController
            let cell = sender as! PhotoCell
            let index = self.photoCollectionView!.indexPathForCell(cell)?.row
            dest.photo = photoLibraryImages[index!]
            dest.albumName = self.albumName
        }
        println("\(segue.identifier)")
    }

}
