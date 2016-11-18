//
//  MenuHelper.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/28/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit

enum Direction {
    case left
    case right
}

struct MenuHelper {
    static let menuWidth : CGFloat = 0.65
    static let percentThreshold : CGFloat = 0.3 // how far (%) the user must pan before the menu changes state
    static let snapshotNumber = 12345  // tag a snapshot view for later retrieval
    static let animationDuration = 0.3 // length of animation (seconds)
    
    // parameters:
    // translationInView = the user’s touch coordinates
    // viewBounds = the screen’s dimensions
    // direction = direction that the slide-out menu is moving
    static func calculateProgress(_ translationInView : CGPoint, viewBounds : CGRect, direction : Direction) -> CGFloat {
        let pointOnAxis = translationInView.x
        let axisLength = viewBounds.width
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis : Float
        let positiveMovementOnAxisPercent : Float
        
        switch direction {
            case .right:
                positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
                positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
                return CGFloat(positiveMovementOnAxisPercent)
            case .left:
                positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
                positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
                return CGFloat(-positiveMovementOnAxisPercent)
        }
    }
    
    
    static func mapGestureStateToInteractor(_ gestureState : UIGestureRecognizerState, progress : CGFloat, interactor : InteractiveTransitionController?, triggerSegue: () -> Void) {
        guard let interactor = interactor else { return }
        switch gestureState {
            case .began:
                interactor.hasStarted = true
                triggerSegue()
            case .changed:
                interactor.shouldFinish = progress > percentThreshold
                interactor.update(progress)
            case .cancelled:
                interactor.hasStarted = false
                interactor.cancel()
            case .ended:
                interactor.hasStarted = false
                interactor.shouldFinish
                    ? interactor.finish()
                    : interactor.cancel()
            default:
                break
        }
    }
}
