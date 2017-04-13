//
//  InviteViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/30/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class InviteViewController: UIViewController {

    let interactor = InteractiveTransitionController()
    
    @IBOutlet weak var navBar: CustomNavigationBar!
    @IBOutlet weak var friendsImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set nav bar to transparent
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        
        // compress friends image
        friendsImageView.image = UIImage(named: "friendAvatars")?.compress(newSize: CGSize(width: 343, height: 219))
    }
    
    @IBAction func pressedInviteFriendsButton(_ sender: SButton) {
        let inviteMessage = [inviteBody]
        let activityViewController = UIActivityViewController(activityItems: inviteMessage, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [.assignToContact, .addToReadingList, .openInIBooks, .postToVimeo, .saveToCameraRoll, .print]
        self.present(activityViewController, animated: true, completion: nil)

    }
}

extension InviteViewController: UIViewControllerTransitioningDelegate {
    
    @IBAction func handleEdgeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(sender.state, progress: progress, interactor: interactor) {
            self.performSegue(withIdentifier: kShowMenuSegue, sender: self)
        }
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(sender.state, progress: progress, interactor: interactor) {
            self.performSegue(withIdentifier: kShowMenuSegue, sender: self)
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ShowMenuAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HideMenuAnimator()
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MenuViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.interactor = interactor
            destinationViewController.currentScreen = .Invite
        }
    }
}
