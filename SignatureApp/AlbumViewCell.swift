//
//  AlbumViewCell.swift
//  SignatureApp
//
//  Created by Ryan Chee on 2/23/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class AlbumViewCell: UICollectionViewCell {
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var imageCell: UIImageView!
    override var bounds: CGRect {
        didSet {
            contentView.frame = bounds
        }
    }
}
