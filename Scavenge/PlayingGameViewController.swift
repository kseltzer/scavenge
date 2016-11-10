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
    var doubleTapGestureRecognizer : UITapGestureRecognizer!
    
    var capturedImages : [UIImage?] = [nil, nil, nil, nil, nil]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = customBackBarItem()
        navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 85
        tableView.scrollsToTop = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func attemptShowImagePicker(_ topic: String) {
        if (capturedImage != nil) {
            return
        }
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            // There is not a camera on this device
            let alertController = UIAlertController(title: kErrorTitle, message: cameraNotAvailableErrorMsg, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: kAcceptFaultErrorMessage, style: .default, handler: nil)
            alertController.addAction(defaultAction)
            return self.present(alertController, animated: true, completion: nil)
        }
        
        if capturedImage != nil {
            capturedImage = nil
        }
        
        let queue = DispatchQueue(label: "imagePickerQueue")
        queue.async(qos: .userInitiated) {
            self.imagePickerController = UIImagePickerController()
            self.imagePickerController.modalPresentationStyle = .currentContext
            self.imagePickerController.sourceType = .camera
            self.imagePickerController.delegate = self
            self.imagePickerController.showsCameraControls = false
            self.imagePickerController.allowsEditing = false
            self.imagePickerController.cameraFlashMode = .auto
    
            self.doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.switchDirectionCameraIsFacing))
            self.doubleTapGestureRecognizer.numberOfTapsRequired = 2
            self.imagePickerController.view.addGestureRecognizer(self.doubleTapGestureRecognizer)
            
            DispatchQueue.main.async {
                Bundle.main.loadNibNamed("CameraOverlayView", owner:self, options:nil)
                self.overlayView.frame = self.imagePickerController.cameraOverlayView!.frame
                self.topView.backgroundColor = NAVIGATION_BAR_TINT_COLOR
                self.bottomView.backgroundColor = NAVIGATION_BAR_TINT_COLOR
                self.selectCapturedImageButton.isHidden = true
                self.topicLabel.text = topic
                self.imagePickerController.cameraOverlayView = self.overlayView
                self.overlayView = nil
                self.present(self.imagePickerController, animated: true, completion: nil)
            }
        }
    }
    
    func setupUIForCapturingImage() {
        cameraFlashButton.isHidden = false
        frontRearFacingCameraButton.isHidden = false
        captureImageButton.isHidden = false
        selectCapturedImageButton.isHidden = true
        capturedImage = nil
        bottomBarStackView.isUserInteractionEnabled = true
        imagePickerController.view.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    func setupUIForReviewingImage() {
        frontRearFacingCameraButton.isHidden = true
        cameraFlashButton.isHidden = true
        captureImageButton.isHidden = true
        selectCapturedImageButton.isHidden = false
        bottomBarStackView.isUserInteractionEnabled = false
        imagePickerController.view.removeGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        capturedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if (imagePickerController.cameraDevice == .front && capturedImage != nil) {
            capturedImage = UIImage(cgImage: (capturedImage!.cgImage)!, scale: (capturedImage!.scale), orientation: UIImageOrientation.leftMirrored)
        } else {
            capturedImage = UIImage(cgImage: (capturedImage!.cgImage)!, scale: (capturedImage!.scale), orientation: .right)
        }
        imageView.image = capturedImage
        self.setupUIForReviewingImage()
    }
    
    func cropImageToSquare(_ image: UIImage) -> UIImage {
        let refWidth = image.cgImage?.width
        let refHeight = image.cgImage?.height
        
        let newWidth = refWidth
        let newHeight = refWidth
        
        let x = (refWidth! - newWidth!) / 2
        let y = (refHeight! - newHeight!) / 2
        
        let cropRect = CGRect(x: x, y: y, width: newWidth!, height: newHeight!)
        let imageRef = image.cgImage?.cropping(to: cropRect)
        let croppedImage = UIImage(cgImage: imageRef!, scale: 0.0, orientation: image.imageOrientation)

        return croppedImage
    }
    
    // MARK: - Top Bar Actions
    
    func cameraViewDoubleTapped(_ sender: UITapGestureRecognizer) {
        if (imagePickerController.cameraDevice == .front) {
            imagePickerController.cameraDevice = .rear
            imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
        } else {
            imagePickerController.cameraDevice = .front
            imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
    }
    
    @IBAction func exitButtonTapped(_ sender: AnyObject) {
        if (capturedImage != nil) {
            // exiting review of image, will return to capture image state
            imageView.image = nil
            self.setupUIForCapturingImage()
        } else {
            // exiting capture image state, will return to topics list
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func flashButtonTapped(_ sender: AnyObject) {
        print("flash: ")
        imagePickerController.showsCameraControls = true // workaround for cameraflashmode bug in iOS 10
        switch (imagePickerController.cameraFlashMode) {
        case .off:
            cameraFlashButton.setImage(UIImage(named: "flashOnButton"), for: UIControlState())
            imagePickerController.cameraFlashMode = .on
            print("turning flash on")
            break
        case .on:
            cameraFlashButton.setImage(UIImage(named: "flashAutoButton"), for: UIControlState())
            imagePickerController.cameraFlashMode = .auto
            print("turning flash on auto")
            break
        case .auto:
            cameraFlashButton.setImage(UIImage(named: "flashOffButton"), for: UIControlState())
            imagePickerController.cameraFlashMode = .off
            print("turning flash off")
            break
        }
        imagePickerController.showsCameraControls = false // workaround for cameraflashmode bug in iOS 10
    }
    
    func switchDirectionCameraIsFacing() {
        if (imagePickerController.cameraDevice == .front) {
            imagePickerController.cameraDevice = .rear
        } else {
            imagePickerController.cameraDevice = .front
        }
    }
    
    @IBAction func frontRearFacingCameraButtonTapped(_ sender: AnyObject) {
        switchDirectionCameraIsFacing()
    }
    
    // MARK: - Bottom Bar Actions
    
    @IBAction func captureImageTapped(_ sender: AnyObject) {
        imagePickerController.takePicture()
    }
    
    @IBAction func selectCapturedImageButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {() -> Void in
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ((indexPath as NSIndexPath).row != NUM_GAME_QUESTIONS) {
            selectedIndex = (indexPath as NSIndexPath).row
            tableView.deselectRow(at: indexPath, animated: true)
            self.attemptShowImagePicker(sampleTopics[(indexPath as NSIndexPath).row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ((indexPath as NSIndexPath).row == NUM_GAME_QUESTIONS) {
            let submitCell = tableView.dequeueReusableCell(withIdentifier: "submitCell", for: indexPath) as! SubmitCell
            return configureSubmitCell(submitCell)
        }
        let topicCell = tableView.dequeueReusableCell(withIdentifier: "topicCell", for: indexPath) as! PlayingGameTopicCell
        return configureTopicCellForIndexPath(topicCell, indexPath: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUM_GAME_QUESTIONS + 1
    }
    
    func setImageForCellAtIndexPath (_ index: Int, image: UIImage?) {
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! PlayingGameTopicCell
        cell.thumbnailImageView.image = cropImageToSquare(image!)
    }
    
    func configureSubmitCell(_ cell: SubmitCell) -> SubmitCell {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToVotingViewController))
        cell.submitButton.addGestureRecognizer(tapGesture)
        if (self.allImagesCaptured) {
            cell.submitButton.isEnabled = true
            cell.submitButton.alpha = 1.0
        } else {
            cell.submitButton.isEnabled = true // TODO: replace true with false
            cell.submitButton.alpha = 0.6
        }
        return cell
    }
    
    func configureTopicCellForIndexPath(_ cell: PlayingGameTopicCell, indexPath: IndexPath) -> PlayingGameTopicCell {
        cell.topicLabel.text = sampleTopics[(indexPath as NSIndexPath).row]
        return cell
    }

    // MARK: - Navigation

    func goToVotingViewController() {
        let playingGameStoryboard = UIStoryboard(name: kPlayingGameStoryboard, bundle: nil)
        let votingViewController = playingGameStoryboard.instantiateViewController(withIdentifier: kVotingViewController)
        navigationController?.replaceStackWithViewController(destinationViewController: votingViewController)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Get the new view controller using segue.destinationViewController.
    }
}
