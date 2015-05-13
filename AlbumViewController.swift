//
//  AlbumViewController.swift
//  SignatureApp
//
//  Created by Ryan Chee on 2/23/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var albumCollectionView: UICollectionView!
    var albumCovers: [AlbumCover] = []
    var albumNameField: UITextField?
    var albumName: String!
//    var tableData: [String] = ["Disneyland", "Disneyworld", "Warriors", "DOTA2: TI5"]
//    var tableImages: [String] = ["Disneyland.jpg", "Disneyworld.jpg", "Warriors.jpg", "ti5.jpg"]
    
    
    @IBAction func addAlbum(sender: AnyObject) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Enter Album Name:", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { [unowned self] action -> Void in
            //Do some stuff
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Ok", style: .Default) { [unowned self] action -> Void in
            if self.albumNameField?.text != nil {
                self.albumName = self.albumNameField!.text
                println(self.albumName)
            }
            let picker = UIImagePickerController()
            picker.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                picker.sourceType = .Camera
            }
            else {
                picker.sourceType = .PhotoLibrary
            }
            self.presentViewController(picker, animated: true, completion: nil)

            //                self.performSegueWithIdentifier("AlbumViewOpen", sender: self)
            //                self.albumName = "Hawaii"
            //Do some other stuff
        }
        actionSheetController.addAction(nextAction)
        //Add a text field
        actionSheetController.addTextFieldWithConfigurationHandler { [unowned self]     textField -> Void in
            //TextField configuration
            textField.textColor = UIColor.blackColor()
            self.albumNameField = textField
        }
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    @IBOutlet weak var collectionViewTable: UICollectionView!
    @IBAction func useCamera() {
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumCovers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AlbumViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumViewCell", forIndexPath: indexPath) as! AlbumViewCell
        let albumCover = albumCovers[indexPath.row]
        cell.imageCell.image = albumCover.image
        cell.labelCell.text = albumCover.title
            //albumCovers[indexPath.row].title
        cell.tag = indexPath.row
        return cell
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        println("we got an image\n");
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        println("BEFORE there are \(albumCovers.count) images")
        
        albumCovers.append(AlbumCover(image: chosenImage, title: albumName))
        dismissViewControllerAnimated(true, completion: nil) //5
        self.collectionViewTable.reloadData()
        println("AFTER there are \(albumCovers.count) images")
        
        let imageData = UIImagePNGRepresentation(chosenImage)
        let imageFile = PFFile(name:"image.png", data: imageData)
        
        
        var userPhoto = PFObject(className:"Albums")
        userPhoto["Name"] = PFUser.currentUser()!.username
        userPhoto["AlbumName"] = albumName
        println("test test test \(albumName)")
        userPhoto["Cover"] = imageFile
        userPhoto.saveInBackgroundWithTarget(nil, selector: nil)
        
    }
    
    
    func populateAlbumArray() {
        var currentUser = PFUser.currentUser()!.username
        var query = PFQuery(className:"Albums")
        query.whereKey("Name", equalTo:"ronald")
        query.findObjectsInBackgroundWithBlock ({(objects:[AnyObject]?, error: NSError?) in
            if(error == nil){
                
                let imageObjects = objects as! [PFObject]
                for object in imageObjects {
                    let thumbNail = object["Cover"] as! PFFile
                    
                    thumbNail.getDataInBackgroundWithBlock({
                    (imageData: NSData?, error: NSError?) -> Void in
                        if (error == nil) {
                            let cover = UIImage(data:imageData!)
                            let title = object["AlbumName"] as! String
                            //image object implementation
                            self.albumCovers.append(AlbumCover(image: cover!, title: title))
                            self.collectionViewTable.reloadData()
                        }
                    })
                }
                println("we got \(imageObjects.count) images!")
            }
            else{
                println("Error in retrieving \(error)")
            }
            
        })//findObjectsInBackgroundWithblock - end
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        populateAlbumArray()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AlbumViewOpen" {
            let dest: PhotoViewController = segue.destinationViewController as! PhotoViewController
            let cell = sender as! AlbumViewCell
            let index = self.albumCollectionView!.indexPathForCell(cell)?.row
            println("index is \(index)")
            dest.albumName = albumCovers[index!].title
        }
    }

}