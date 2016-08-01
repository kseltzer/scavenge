//
//  PlayingGameViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/13/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class PlayingGameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var cameraFlashButton: UIButton!
    @IBOutlet weak var frontRearFacingCameraButton: UIButton!
    @IBOutlet weak var selectCapturedImageButton: UIButton!
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var bottomBarStackView: UIStackView!
    
    @IBOutlet weak var imageView : UIImageView!
    
    var imagePickerController : UIImagePickerController!
    var capturedImage : UIImage?
    
    @IBAction func cameraButtonPressed (sender: UIButton!) {
        self.showImagePicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            // There is not a camera on this device, so don't show the camera button.
            
        } else {
            
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func showImagePicker() {
        if capturedImage != nil {
            capturedImage = nil
        }
        
        imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .CurrentContext
        imagePickerController.sourceType = .Camera
        imagePickerController.delegate = self
        imagePickerController.showsCameraControls = false
        imagePickerController.allowsEditing = true
        imagePickerController.cameraFlashMode = .Off
        
        NSBundle.mainBundle().loadNibNamed("CameraOverlayView", owner:self, options:nil)
        overlayView.frame = imagePickerController.cameraOverlayView!.frame
        selectCapturedImageButton.hidden = true
        imagePickerController.cameraOverlayView = overlayView
        overlayView = nil
        
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func setupUIForCapturingImage() {
        cameraFlashButton.hidden = false
        frontRearFacingCameraButton.hidden = false
        captureImageButton.hidden = false
        selectCapturedImageButton.hidden = true
        capturedImage = nil
        bottomBarStackView.userInteractionEnabled = true
    }
    
    func setupUIForReviewingImage() {
        frontRearFacingCameraButton.hidden = true
        cameraFlashButton.hidden = true
        captureImageButton.hidden = true
        selectCapturedImageButton.hidden = false
        bottomBarStackView.userInteractionEnabled = false
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = capturedImage
        self.setupUIForReviewingImage()
    }
    
    
    // MARK: - Top Bar Actions
    
    @IBAction func exitButtonTapped(sender: AnyObject) {
        if (capturedImage != nil) {
            // exiting review of image, will return to capture image state
            imageView.image = nil
            self.setupUIForCapturingImage()
        } else {
            // exiting capture image state, will return to topics list
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func flashButtonTapped(sender: AnyObject) {
        switch (imagePickerController.cameraFlashMode) {
        case .Off:
            imagePickerController.cameraFlashMode = .On
            print("turning flash on")
            break
        case .On:
            imagePickerController.cameraFlashMode = .Auto
            print("turning flash on auto")
            break
        case .Auto:
            imagePickerController.cameraFlashMode = .Off
            print("turning flash off")
            break
        }
    }
    
    @IBAction func frontRearFacingCameraButtonTapped(sender: AnyObject) {
        if (imagePickerController.cameraDevice == .Front) {
            imagePickerController.cameraDevice = .Rear
            imageView.transform = CGAffineTransformMakeScale(1, 1)
        } else {
            imagePickerController.cameraDevice = .Front
            imageView.transform = CGAffineTransformMakeScale(-1, 1)
        }
    }
    
    // MARK: - Bottom Bar Actions
    
    @IBAction func captureImageTapped(sender: AnyObject) {
        imagePickerController.takePicture()
    }
    
    @IBAction func selectCapturedImageButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
