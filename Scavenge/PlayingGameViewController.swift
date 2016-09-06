//
//  PlayingGameViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/13/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

let sampleTopics = ["The Epitome of Disappointment", "So Crazy It Just Might Work", "Public Selfie", "The Perfect Balance Between Business and Casual", "Sachin's Worst Nightmare"]

class PlayingGameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let cameraNotAvailableErrorMsg = "ya need a camera to play Scavenge, and this device doesn't have one"
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var overlayTopView: UIView!
    @IBOutlet weak var overlayBottomView: UIView!
    @IBOutlet weak var cameraFlashButton: UIButton!
    @IBOutlet weak var frontRearFacingCameraButton: UIButton!
    @IBOutlet weak var selectCapturedImageButton: UIButton!
    @IBOutlet weak var captureImageButton: UIButton!
    @IBOutlet weak var bottomBarStackView: UIStackView!
    @IBOutlet weak var topicLabel: UILabel!
    
    @IBOutlet weak var imageView : UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: SButton!
    
    var imagePickerController : UIImagePickerController!
    var capturedImage : UIImage?
    var selectedIndex : Int!
    var allImagesCaptured : Bool = false
    
    var capturedImages : [UIImage?] = [nil, nil, nil, nil, nil]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = customBackBarItem()
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 85
        tableView.scrollsToTop = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func attemptShowImagePicker(topic: String) {
        if (capturedImage != nil) {
            return
        }
        
        if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
            // There is not a camera on this device
            let alertController = UIAlertController(title: kErrorTitle, message: cameraNotAvailableErrorMsg, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: kAcceptFaultErrorMessage, style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            return self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        
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
        topView.backgroundColor = NAVIGATION_BAR_TINT_COLOR
        bottomView.backgroundColor = NAVIGATION_BAR_TINT_COLOR
        selectCapturedImageButton.hidden = true
        topicLabel.text = topic
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
        if (imagePickerController.cameraDevice == .Front && capturedImage != nil) {
            capturedImage = UIImage(CGImage: (capturedImage!.CGImage)!, scale: (capturedImage!.scale), orientation: UIImageOrientation.LeftMirrored)
        } else {
            capturedImage = UIImage(CGImage: (capturedImage!.CGImage)!, scale: (capturedImage!.scale), orientation: .Right)
        }
        imageView.image = capturedImage
        self.setupUIForReviewingImage()
    }
    
    func cropImageToSquare(image: UIImage) -> UIImage {
        let refWidth = CGImageGetWidth(image.CGImage)
        let refHeight = CGImageGetHeight(image.CGImage)
        
        let newWidth = refWidth
        let newHeight = refWidth
        
        let x = (refWidth - newWidth) / 2
        let y = (refHeight - newHeight) / 2
        
        let cropRect = CGRect(x: x, y: y, width: newWidth, height: newHeight)
        let imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect)
        let croppedImage = UIImage(CGImage: imageRef!, scale: 0.0, orientation: image.imageOrientation)

        return croppedImage
    }
    
    // MARK: - Top Bar Actions
    
    func cameraViewDoubleTapped(sender: UITapGestureRecognizer) {
        if (imagePickerController.cameraDevice == .Front) {
            imagePickerController.cameraDevice = .Rear
            imageView.transform = CGAffineTransformMakeScale(1, 1)
        } else {
            imagePickerController.cameraDevice = .Front
            imageView.transform = CGAffineTransformMakeScale(-1, 1)
        }
    }
    
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
            cameraFlashButton.setImage(UIImage(named: "flashOnButton"), forState: .Normal)
            print("turning flash on")
            break
        case .On:
            imagePickerController.cameraFlashMode = .Auto
            cameraFlashButton.setImage(UIImage(named: "flashAutoButton"), forState: .Normal)
            print("turning flash on auto")
            break
        case .Auto:
            imagePickerController.cameraFlashMode = .Off
            cameraFlashButton.setImage(UIImage(named: "flashOffButton"), forState: .Normal)
            print("turning flash off")
            break
        }
    }
    
    @IBAction func frontRearFacingCameraButtonTapped(sender: AnyObject) {
        if (imagePickerController.cameraDevice == .Front) {
            imagePickerController.cameraDevice = .Rear
        } else {
            imagePickerController.cameraDevice = .Front
        }
    }
    
    // MARK: - Bottom Bar Actions
    
    @IBAction func captureImageTapped(sender: AnyObject) {
        imagePickerController.takePicture()
    }
    
    @IBAction func selectCapturedImageButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {() -> Void in
            self.setImageForCellAtIndexPath(self.selectedIndex, image: self.capturedImage)
            self.capturedImages[self.selectedIndex] = self.capturedImage
            self.capturedImage = nil
            
            self.allImagesCaptured = true
            for image in self.capturedImages {
                if (image == nil) {
                    self.allImagesCaptured = false
                }
            }
            if (self.allImagesCaptured) {
                self.tableView.reloadData()
            }
        })
    }

    // MARK :- UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row != NUM_GAME_QUESTIONS) {
            selectedIndex = indexPath.row
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.attemptShowImagePicker(sampleTopics[indexPath.row])
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == NUM_GAME_QUESTIONS) {
            let submitCell = tableView.dequeueReusableCellWithIdentifier("submitCell", forIndexPath: indexPath) as! SubmitCell
            return configureSubmitCell(submitCell)
        }
        let topicCell = tableView.dequeueReusableCellWithIdentifier("topicCell", forIndexPath: indexPath) as! PlayingGameTopicCell
        return configureTopicCellForIndexPath(topicCell, indexPath: indexPath)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUM_GAME_QUESTIONS + 1
    }
    
    func setImageForCellAtIndexPath (index: Int, image: UIImage?) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! PlayingGameTopicCell
        cell.thumbnailImageView.image = cropImageToSquare(image!)
    }
    
    func configureSubmitCell(cell: SubmitCell) -> SubmitCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToVotingViewController))
        cell.submitButton.addGestureRecognizer(tapGesture)
        if (self.allImagesCaptured) {
            cell.submitButton.enabled = true
            cell.submitButton.alpha = 1.0
        } else {
            cell.submitButton.enabled = false
            cell.submitButton.alpha = 0.6
        }
        return cell
    }
    
    func configureTopicCellForIndexPath(cell: PlayingGameTopicCell, indexPath: NSIndexPath) -> PlayingGameTopicCell {
        cell.topicLabel.text = sampleTopics[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    func goToVotingViewController() {
        self.performSegueWithIdentifier("showVoting", sender: self)
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
