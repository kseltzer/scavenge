//
//  InvitationCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 11/19/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

let kBounceValue : CGFloat = 8.0
let acceptColor = UIColor(red: 23/255, green: 163/255, blue: 84/255, alpha: 1.0)
let declineColor = UIColor.red
let defaultViewBackgroundColor = UIColor.white

protocol InvitationCellProtocol {
    func acceptedGameInvite(cell: InvitationCell)
    func declinedGameInvite(cell: InvitationCell)
}

class InvitationCell: UITableViewCell {
    var delegate : InvitationCellProtocol!
    var isOpen : Bool = false
    
    var panStartingPoint : CGPoint?
    var startingTrailingHideButtonsViewConstant : CGFloat?
    
    @IBOutlet weak var acceptButton : UIButton!
    @IBOutlet weak var declineButton : UIButton!
    
    @IBOutlet weak var gameTitleLabel : UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var invitedByLabel: UILabel!
    
    @IBOutlet weak var hideButtonsView: UIView!
    @IBOutlet weak var roundedBorderView: RoundedBorderedView!
    
    
    @IBOutlet weak var hideButtonsViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var hideButtonsViewLeadingConstraint: NSLayoutConstraint!
    
    @IBAction func acceptButtonTapped(_ sender: AnyObject) {
        delegate.acceptedGameInvite(cell: self)
    }
    
    @IBAction func declineButtonTapped(_ sender: AnyObject) {
        delegate.declinedGameInvite(cell: self)
    }
    
    func getTotalButtonWidth() -> CGFloat {
        return acceptButton.frame.width + declineButton.frame.width
    }
    
    func resetConstraintConstantsToZero() {
        if (startingTrailingHideButtonsViewConstant == 0 && hideButtonsViewTrailingConstraint.constant == 0) { // already closed, no bounce necessary
            return
        }
        
        hideButtonsViewTrailingConstraint.constant = -kBounceValue
        hideButtonsViewLeadingConstraint.constant = 2 * kBounceValue
        
        updateConstraintsIfNeeded { (finished) in
            self.hideButtonsViewTrailingConstraint.constant = 8
            self.hideButtonsViewLeadingConstraint.constant = 8
            
            self.updateConstraintsIfNeeded(with: { (finished) in
                self.startingTrailingHideButtonsViewConstant = self.hideButtonsViewTrailingConstraint.constant
            })
        }
    }
    
    func setConstraintsToShowAllButtons() {
        if (startingTrailingHideButtonsViewConstant == getTotalButtonWidth()-2 && hideButtonsViewTrailingConstraint.constant == getTotalButtonWidth()-2) {
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
    
    func resetAppearanceIfNeeded() {
        if (roundedBorderView.backgroundColor != defaultViewBackgroundColor) {
            roundedBorderView.backgroundColor = defaultViewBackgroundColor
            acceptButton.backgroundColor = acceptColor
            declineButton.backgroundColor = declineColor
            resetConstraintConstantsToZero()
            isOpen = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetAppearanceIfNeeded()
    }
    
}

