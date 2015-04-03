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
    
    var tableData: [String] = ["Disneyland", "Disneyworld", "Warriors", "DOTA2: TI5"]
    var tableImages: [String] = ["Disneyland.jpg", "Disneyworld.jpg", "Warriors.jpg", "ti5.jpg"]
        
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AlbumViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("AlbumViewCell", forIndexPath: indexPath) as AlbumViewCell
        cell.imageCell.image = UIImage(named: tableImages[indexPath.row])
        cell.labelCell.text = tableData[indexPath.row]
        cell.tag = indexPath.row
        return cell
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