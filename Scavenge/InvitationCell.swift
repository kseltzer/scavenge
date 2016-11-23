//
//  InvitationCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 11/19/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

let kBounceValue : CGFloat = 8.0

protocol InvitationCellProtocol {
    func acceptedGameInvite()
    func declinedGameInvite()
}

class InvitationCell: UITableViewCell {
    var delegate : InvitationCellProtocol!
    var isOpen : Bool = false
    
    var panStartingPoint : CGPoint?
    var startingTrailingHideButtonsViewConstant : CGFloat?
    
    @IBOutlet weak var acceptButton : UIButton!
    @IBOutlet weak var declineButton : UIButton!
    @IBOutlet weak var gameTitleLabel : UILabel!
    
    @IBOutlet weak var hideButtonsView: UIView!
    
    @IBOutlet weak var hideButtonsViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var hideButtonsViewLeadingConstraint: NSLayoutConstraint!
    
    @IBAction func acceptButtonTapped(_ sender: AnyObject) {
        delegate.acceptedGameInvite()
    }
    
    @IBAction func declineButtonTapped(_ sender: AnyObject) {
        delegate.declinedGameInvite()
    }
    
    func getTotalButtonWidth() -> CGFloat {
        return acceptButton.frame.width + declineButton.frame.width
    }
    
    func resetConstraintConstantsToZero() {
        if (startingTrailingHideButtonsViewConstant == 0 && hideButtonsViewTrailingConstraint.constant == 0) { // already closed, no bounce necessary
            return
        }
        
        hideButtonsViewTrailingConstraint.constant = -kBounceValue
        hideButtonsViewLeadingConstraint.constant = 16 //kBounceValue
        
        updateConstraintsIfNeeded { (finished) in
            self.hideButtonsViewTrailingConstraint.constant = 8
            self.hideButtonsViewLeadingConstraint.constant = 8
            
            self.updateConstraintsIfNeeded(with: { (finished) in
                self.startingTrailingHideButtonsViewConstant = self.hideButtonsViewTrailingConstraint.constant
            })
        }
    }
    
    func setConstraintsToShowAllButtons() {
        if (startingTrailingHideButtonsViewConstant == getTotalButtonWidth() && hideButtonsViewTrailingConstraint.constant == getTotalButtonWidth()) {
            return
        }
        
        hideButtonsViewLeadingConstraint.constant = -getTotalButtonWidth() - kBounceValue
        hideButtonsViewTrailingConstraint.constant = getTotalButtonWidth() + kBounceValue
        
        updateConstraintsIfNeeded { (finished) in
            self.hideButtonsViewLeadingConstraint.constant = -self.getTotalButtonWidth() + 2
            self.hideButtonsViewTrailingConstraint.constant = self.getTotalButtonWidth() - 2
            
            self.updateConstraintsIfNeeded(with: { (finished) in
                self.startingTrailingHideButtonsViewConstant = self.hideButtonsViewTrailingConstraint.constant
            })
        }
        
        startingTrailingHideButtonsViewConstant = hideButtonsViewTrailingConstraint.constant
    }
    
    func updateConstraintsIfNeeded(with completion: (@escaping (Bool) -> Swift.Void)) {
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
            }, completion: completion)
        }
    }

