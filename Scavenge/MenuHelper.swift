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
    case Left
    case Right
}

struct MenuHelper {
    static let menuWidth : CGFloat = 0.65
    static let percentThreshold : CGFloat = 0.4 // how far (%) the user must pan before the menu changes state
    static let snapshotNumber = 12345  // tag a snapshot view for later retrieval
    static let animationDuration = 0.3 // length of animation (seconds)
    
    // parameters:
    // translationInView = the user’s touch coordinates
    // viewBounds = the screen’s dimensions
    // direction = direction that the slide-out menu is moving
    static func calculateProgress(translationInView : CGPoint, viewBounds : CGRect, direction : Direction) -> CGFloat {
        let pointOnAxis = translationInView.x
        let axisLength = viewBounds.width
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis : Float
        let positiveMovementOnAxisPercent : Float
        
        switch direction {
            case .Right:
                positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
                positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
                return CGFloat(positiveMovementOnAxisPercent)
            case .Left:
                positiveMovementOnAxis = fminf(Float(movementOnAxis), 0.0)
                positiveMovementOnAxisPercent = fmaxf(positiveMovementOnAxis, -1.0)
                return CGFloat(-positiveMovementOnAxisPercent)
        }
    }
    
    
    static func mapGestureStateToInteractor(gestureState : UIGestureRecognizerState, progress : CGFloat, interactor : InteractiveMenuTransition?, triggerSegue: () -> Void) {
        guard let interactor = interactor else { return }
        switch gestureState {
            case .Began:
                interactor.hasStarted = true
                triggerSegue()
            case .Changed:
                interactor.shouldFinish = progress > percentThreshold
                interactor.updateInteractiveTransition(progress)
            case .Cancelled:
                interactor.hasStarted = false
                interactor.cancelInteractiveTransition()
            case .Ended:
                interactor.hasStarted = false
                interactor.shouldFinish
                    ? interactor.finishInteractiveTransition()
                    : interactor.cancelInteractiveTransition()
            default:
                break
        }
    }
}