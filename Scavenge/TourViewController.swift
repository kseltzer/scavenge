//
//  TourViewController.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/29/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class TourViewController: UIViewController {

    let interactor = InteractiveTransitionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

// MARK: - Slideout Menu

extension TourViewController: UIViewControllerTransitioningDelegate {
   
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
            destinationViewController.currentScreen = .Tour
        }
    }
}
