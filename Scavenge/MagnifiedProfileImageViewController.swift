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
    
    var interactor: InteractiveMenuTransition? = nil

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
        imageView.image = playerImage
        let maskPath = UIBezierPath(arcCenter: CGPoint(x: imageView.bounds.size.width/2, y: imageView.bounds.size.height/2), radius: (imageView.frame.size.width / 2.0) - 0.5, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: false)
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.strokeColor = UIColor.white.cgColor
        imageView.layer.mask = maskLayer
        imageView.layer.masksToBounds = true
        let borderShape = CAShapeLayer()
        borderShape.frame = imageView.layer.bounds
        borderShape.path = maskPath.cgPath
        borderShape.strokeColor = UIColor.white.cgColor
        borderShape.fillColor = nil
        borderShape.lineWidth = 4.0
        imageView.layer.addSublayer(borderShape)
        
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
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            if (interactor.shouldFinish) {
                self.delegate.hideOverlayView()
            }
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
    }
    
}
