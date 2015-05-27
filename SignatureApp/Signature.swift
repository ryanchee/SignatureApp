//
//  Signature.swift
//  SignatureApp
//
//  Created by Ryan Chee on 5/26/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import Foundation

class Signature {
    var signatureImage: UIImage?
    var signatureName: String?
    
    
    init(signature: UIImage, signatureName: String) {
        self.signatureImage = signature
        self.signatureName = signatureName
    }
}