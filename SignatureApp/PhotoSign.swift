//
//  PhotoSign.swift
//  SignatureApp
//
//  Created by Ryan Chee on 3/23/15.
//  Copyright (c) 2015 Ryan Chee. All rights reserved.
//

import UIKit

class PhotoSign: UIView {
    
    @IBOutlet var drawView: PhotoSign!
    var lines: [Line] = []
    var lastPoint: CGPoint!
   
    var drawColor: UIColor = UIColor.blackColor()
    var rainbowButton = false
    var photo: UIImage?
    var signed = false
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            lastPoint = touch.locationInView(self)
        }
        super.touchesBegan(touches , withEvent:event)
        signed = true
    }
    

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let touch = touches.first as? UITouch {
            var newPoint = touch.locationInView(self)
            if rainbowButton == true {
                drawColor = getRandomColor()
            }
            lines.append(Line(start: lastPoint, end: newPoint, color: drawColor))
            lastPoint = newPoint
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        var context = UIGraphicsGetCurrentContext()
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, 5)
        for line in lines {
            CGContextBeginPath(context)
            CGContextMoveToPoint(context, line.start.x, line.start.y)
            CGContextAddLineToPoint(context, line.end.x, line.end.y)
            CGContextSetStrokeColorWithColor(context, line.color.CGColor)
            CGContextStrokePath(context)
        }
    }
    
    func getRandomColor() -> UIColor {
        var randomRed: CGFloat = CGFloat(drand48())
        var randomGreen: CGFloat = CGFloat(drand48())
        var randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    

}
