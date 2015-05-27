//
//  Line.swift
//  SignatureApp
//
//  Created by Ryan Chee on 3/23/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class Line {
    var start: CGPoint
    var end: CGPoint
    var color: UIColor

    init(start _start:CGPoint , end _end:CGPoint, color _color:UIColor!) {
        start = _start
        end = _end
        color = _color
    }
}

