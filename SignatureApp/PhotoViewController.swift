//
//  PhotoViewController.swift
//  SignatureApp
//
//  Created by Ryan Chee on 2/24/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let image = UIImagePickerController()
    let imageNum = 0;
    var tableImages: [String] = ["mulan.jpg", "lilo.jpg", "anna.jpg", "timon.jpg", "jafar.jpg", "elsa.jpg", "pluto.jpg", "jack.jpg", "tangled.jpg"]
    var iter = 0
    var photoLibraryImages: [UIImage] = []
    //var imageSelected: UIImage
    
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
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        println("we got an image\n");
        let chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage //2
        println("BEFORE there are \(photoLibraryImages.count) images")
        photoLibraryImages.append(chosenImage)
        dismissViewControllerAnimated(true, completion: nil) //5
        self.collectionView.reloadData()
        println("AFTER there are \(photoLibraryImages.count) images")

    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("there are \(photoLibraryImages.count) images")
        return photoLibraryImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            var cell: PhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as PhotoCell
            cell.photoCell.image = photoLibraryImages[indexPath.row]
            iter++
            return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        println("PhotoViewCell \(indexPath.row) selected");
        let cell: PhotoCell = collectionView.cellForItemAtIndexPath(indexPath) as PhotoCell
      //  imageSelected = cell.photoCell.image!
        performSegueWithIdentifier("PhotoEdit", sender: self)
    }
    
/*    override func viewDidAppear(animated: Bool) {
        println("should be reloading\n");
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        println("should load\n");
        image.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PhotoEdit" {
            let controller: PhotoSign = segue.destinationViewController as PhotoSign
  //          controller.photo = imageSelected
            //            controller.num = sender.tag
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
