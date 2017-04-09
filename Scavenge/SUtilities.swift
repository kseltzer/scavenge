//
//  SUtilities.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/14/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit

func customBackBarItem (title: String = "") -> SBarButtonItem {
    let barButtonItem = SBarButtonItem(title: title, style: .plain, target: nil, action: nil)
    return barButtonItem
}

func customBarButtonItemWith (image: UIImage) -> UIBarButtonItem {
    let button = UIButton.init(type: .custom)
    button.setImage(image, for: UIControlState.normal)
    button.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
    return UIBarButtonItem(customView: button)

//    self.navigationItem.rightBarButtonItem = barButton
}

extension UIImageView {
    func circular() {
        layer.cornerRadius = frame.height / 2.0
        clipsToBounds = true
    }
}

extension UIImage {
    func compress(newSize: CGSize = CGSize(width: 46, height: 44)) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        let imageRef = self.cgImage
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        // Set the quality level to use when rescaling
        context?.interpolationQuality = .high
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
        
        context?.concatenate(flipVertical)
        // Draw into the context; this scales the image
        context?.draw(imageRef!, in: newRect)
        
        let newImageRef = context?.makeImage()
        let newImage = UIImage(cgImage: newImageRef!)
        
        // Get the resized image from the context and a UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


