//
//  NetworkImageView.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/14/17.
//  Copyright © 2017 Kim Seltzer. All rights reserved.
//

import UIKit

protocol NetworkImageViewDelegate : NSObjectProtocol {
    func networkImageLoaded(image: UIImage?)
}

class NetworkImageView: UIImageView {
    
    var image_url: String? = nil {
        didSet {
            self.loadImageFromURL()
        }
    }
        
    weak var delegate: NetworkImageViewDelegate?
    
    func loadImageFromURL() {
        
        self.image = nil
        
        if (self.image_url == nil || self.image_url == "") {
            return
        }
        
        // Store copy of currently loading item (in case changes during async)
        let url_before_async = self.image_url
        
        // Load asynchronously
        DispatchQueue.global(qos: .default).async {
            
            if let url = URL(string: self.image_url!) {
                
                do {
                    
                    let sanitized_url = self.image_url!.replacingOccurrences(of: ":", with: "-").replacingOccurrences(of: "/", with: "-")
                    let path = NSTemporaryDirectory() + sanitized_url
                    
                    if (FileManager.default.fileExists(atPath: path)) { // Use cached image
                        
                        if let cached_image = UIImage(contentsOfFile: path) {
                            
                            // Check if still loading image from same url
                            if (self.image_url == url_before_async) {
                                
                                // Set image on main thread
                                DispatchQueue.main.async {
                                    self.image = cached_image
                                    self.delegate?.networkImageLoaded(image: self.image)
                                }
                            }
                            
                        } else {
                            print("Couldn't load image from cache: \(path)")
                        }
                        
                        return
                    }
                    
                    let data = try Data(contentsOf: url)
                    
                    if let downloaded_image = UIImage(data: data) {
                        
                        // Check if still loading image for the same item
                        if (self.image_url == url_before_async) {
                            
                            // Set image on main thread
                            DispatchQueue.main.async {
                                self.image = downloaded_image
                                self.delegate?.networkImageLoaded(image: self.image)
                            }
                        }
                        
                        // Write image to cache
                        let fileURL = URL(fileURLWithPath: path, isDirectory: false)
                        try data.write(to: fileURL, options: .atomic)
                        
                    } else {
                        print("Data could not be converted to image: \(self.image_url!)")
                    }
                    
                }
                catch _ {
                    print("Couldn't load image from url: \(self.image_url!)")
                }
                
            }
            
            
        }
        
    }
    
}
