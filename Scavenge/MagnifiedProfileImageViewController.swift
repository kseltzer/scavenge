//
//  MagnifiedProfileImageViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 11/15/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

protocol MagnifiedProfileImageViewDelegate {
    func xButtonTapped()
    func hideOverlayView()
}

class MagnifiedProfileImageViewController: UIViewController {
    
    var delegate: MagnifiedProfileImageViewDelegate!

    @IBOutlet weak var magnifiedProfileImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    var playerImage: UIImage!
    var playerName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        magnifiedProfileImageView.layer.cornerRadius = 13
        imageView.layoutIfNeeded()
        imageView.layer.cornerRadius = imageView.frame.height / 2.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4.0
        imageView.image = playerImage
        nameLabel.text = playerName
        checkmarkButton.layoutIfNeeded()
        checkmarkButton.layer.cornerRadius = checkmarkButton.frame.height / 2.0
        xButton.layoutIfNeeded()
        xButton.layer.cornerRadius = checkmarkButton.frame.height / 2.0
    }
    
    @IBAction func backgroundTapped(_ sender: AnyObject) {
        delegate.hideOverlayView()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swipedDownOnBackground(_ sender: AnyObject) {
        delegate.hideOverlayView()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func xButtonTapped(_ sender: AnyObject) {
        delegate.hideOverlayView()
        self.dismiss(animated: true, completion: {() -> Void in
            self.delegate.xButtonTapped()
        })
    }
    
    @IBAction func checkmarkButtonTapped(_ sender: AnyObject) {
        delegate.hideOverlayView()
        self.dismiss(animated: true, completion: nil)
    }
}
