//
//  SUtilities.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/14/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit
import AWSS3

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

func downloadImageFromBucket(key: String) -> UIImage? {
    let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(key).jpg")
    
    if let downloadRequest = AWSS3TransferManagerDownloadRequest() {
        
        downloadRequest.bucket = AWS_BUCKET
        downloadRequest.key = "\(key).jpg"
        downloadRequest.downloadingFileURL = downloadingFileURL
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.download(downloadRequest).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as? NSError {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error downloading: \(downloadRequest.key).jpg Error: \(error)")
                    }
                } else {
                    print("Error downloading: \(downloadRequest.key).jpg Error: \(error)")
                }
                return nil
            }
            print("Download complete for: \(downloadRequest.key).jpg")
//            let downloadOutput = task.result
            
            return UIImage(contentsOfFile: downloadingFileURL.path)
        })
    }
    
    return nil
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
    
    func uploadToBucket(key: String) {
        let transferManager = AWSS3TransferManager.default()
        
        let ext = "jpg"
        let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(key).jpg")!
        
        // save image to URL
        do {
            try UIImageJPEGRepresentation(self, 1)?.write(to: imageURL)
        } catch { print("couldn't save") }
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = AWS_BUCKET
        uploadRequest?.key = ProcessInfo.processInfo.globallyUniqueString + "." + ext
        uploadRequest?.body = imageURL
        uploadRequest?.contentType = "image/" + ext
        
        if let request = uploadRequest {
            transferManager.upload(request).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                // Do something with the response
                if let error = task.error {
                    print("Upload failed ❌ (\(error))")
                }
                if task.result != nil {
                    let s3URL2 = URL(string: "http://s3.amazonaws.com/\(AWS_BUCKET)/\(key).jpg")
                    print("Uploaded to:\n\(s3URL2)")
                }
                else {
                    print("Unexpected empty result.")
                }
                return nil
            })
            
        }
    }
}


// MARK: - Icon Constants
enum GameIcon: Int {
    case raccoon = 0
    case hyena = 1
    case jackal = 2
    case possum = 3
    case rat = 4
    case tasmanianDevil = 5
    case vulture = 6
    case yellowJacket = 7
    case crow = 8
}

func getImageFrom(icon: Int) -> UIImage {
    var imageName: String = "raccoon2"
    
    switch icon {
    case GameIcon.raccoon.rawValue:
        imageName = "raccoon2"
        break
    case GameIcon.hyena.rawValue:
        imageName = "hyena"
        break
    case GameIcon.jackal.rawValue:
        imageName = "jackal"
        break
    case GameIcon.possum.rawValue:
        imageName = "possum"
        break
    case GameIcon.rat.rawValue:
        imageName = "rat"
        break
    case GameIcon.tasmanianDevil.rawValue:
        imageName = "tasmanianDevil"
        break
    case GameIcon.vulture.rawValue:
        imageName = "vulture"
        break
    case GameIcon.yellowJacket.rawValue:
        imageName = "yellowJacket"
        break
    case GameIcon.crow.rawValue:
        imageName = "crow"
        break
    default:
        break
    }
    
    return UIImage(named: imageName)!
}

