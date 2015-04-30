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
    var albumCovers: [UIImage] = []
    var tableData: [String] = ["Disneyland", "Disneyworld", "Warriors", "DOTA2: TI5"]
    var tableImages: [String] = ["Disneyland.jpg", "Disneyworld.jpg", "Warriors.jpg", "ti5.jpg"]
    
    
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
        return tableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AlbumViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumViewCell", forIndexPath: indexPath) as! AlbumViewCell
        cell.imageCell.image = UIImage(named: tableImages[indexPath.row])
        cell.labelCell.text = tableData[indexPath.row]
            //albumCovers[indexPath.row].title
        cell.tag = indexPath.row
        return cell
    }
    
    func populateAlbumArray() {
        var currentUser = PFUser.currentUser()!.username
        var query = PFQuery(className:"UserPhoto")
        query.whereKey("Name", equalTo:"ronald")
//        query.findObjectsInBackgroundWithBlock(<#block: PFArrayResultBlock?##([AnyObject]?, NSError?) -> Void#>)
        query.findObjectsInBackgroundWithBlock ({(objects:[AnyObject]?, error: NSError?) in
            if(error == nil){
                
                let imageObjects = objects as! [PFObject]
                
                for object in imageObjects {
                    
                    let album = object["Picture"] as! AlbumCover
                    println("we got \(imageObjects.count) images!")
//                    album.getDataInBackgroundWithBlock({
  //                      (imageData: NSData!, error: NSError!) -> Void in
    //                    if (error == nil) {
                            let image = album.image
                         //   let title = album.title
                         //   let albumToPopulate =
                    //AlbumCover(image: image, title: title)
                            //image object implementation
                            self.albumCovers.append(image)
                            self.collectionViewTable.reloadData()
      //                  }
      //
      //              })//getDataInBackgroundWithBlock - end
                    
                }//for - end
                // self.collectionView.reloadData()
            }
            else{
                println("Error in retrieving \(error)")
            }
            
        })//findObjectsInBackgroundWithblock - end
        

    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
     //   self.performSegueWithIdentifier("AlbumViewOpen", sender: self)
        println("AlbumViewCell \(indexPath.row) selected");
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "AlbumViewOpen" {
//            let controller: PhotoViewController = segue.destinationViewController as PhotoViewController
//            controller.num = sender.tag
//        }
//    }
    
    

}