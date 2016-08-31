//
//  RightToLeftAnimator.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/31/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class RightToLeftAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return MenuHelper.animationDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let finalFrameForVC = transitionContext.finalFrameForViewController(toVC)
        let containerView = transitionContext.containerView()
        toVC.view.frame = CGRectOffset(finalFrameForVC, UIScreen.mainScreen().bounds.width * MenuHelper.menuWidth, 0)
        containerView!.addSubview(toVC.view)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            toVC.view.frame = finalFrameForVC
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
        })
    }
}
