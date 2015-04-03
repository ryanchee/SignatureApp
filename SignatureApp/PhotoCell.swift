//
//  PhotoCell.swift
//  SignatureApp
//
//  Created by Ryan Chee on 2/24/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photoCell: UIImageView!
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
}
