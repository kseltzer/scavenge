//
//  InvitationCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 11/19/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

let kBounceValue : CGFloat = 8.0
let acceptColor = COLOR_GREEN
let declineColor = COLOR_RED
let defaultViewBackgroundColor = CELL_DEFAULT_COLOR_HOME

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        gameImageView.layer.cornerRadius =  gameImageView.frame.size.height * 3/4
        roundedBorderView.backgroundColor = defaultViewBackgroundColor
    }
    
    @IBAction func acceptButtonTapped(_ sender: AnyObject) {
        if (isOpen) {
            delegate.acceptedGameInvite(cell: self)
        }
    }
    
    @IBAction func declineButtonTapped(_ sender: AnyObject) {
        delegate.declinedGameInvite(cell: self)
    }
    
    func getTotalButtonWidth() -> CGFloat {
        return acceptButton.frame.width + declineButton.frame.width
    }
    
    func resetConstraintConstantsToZero(animated: Bool) {
        if (startingTrailingHideButtonsViewConstant == 8 && hideButtonsViewTrailingConstraint.constant == 8) { // already closed, no bounce necessary
            return
        }
        
        if (animated) {
            hideButtonsViewTrailingConstraint.constant = -kBounceValue
            hideButtonsViewLeadingConstraint.constant = 2 * kBounceValue
        }
        
        updateConstraintsIfNeeded { (finished) in
            self.hideButtonsViewTrailingConstraint.constant = 8
            self.hideButtonsViewLeadingConstraint.constant = 8
            
            self.updateConstraintsIfNeeded(with: { (finished) in
                self.startingTrailingHideButtonsViewConstant = self.hideButtonsViewTrailingConstraint.constant
            })
        }
    }
    
    func setConstraintsToShowAllButtons(animated: Bool) {
        if (startingTrailingHideButtonsViewConstant == getTotalButtonWidth()-2 && hideButtonsViewTrailingConstraint.constant == getTotalButtonWidth()-2) { // already open
            return
        }
        
        if (animated) {
            hideButtonsViewLeadingConstraint.constant = -getTotalButtonWidth() - kBounceValue
            hideButtonsViewTrailingConstraint.constant = getTotalButtonWidth() + kBounceValue
        
            updateConstraintsIfNeeded { (finished) in
                self.hideButtonsViewLeadingConstraint.constant = -self.getTotalButtonWidth() + 2
                self.hideButtonsViewTrailingConstraint.constant = self.getTotalButtonWidth() - 2
                
                self.updateConstraintsIfNeeded(with: { (finished) in
                    self.startingTrailingHideButtonsViewConstant = self.hideButtonsViewTrailingConstraint.constant
                })
            }
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
            resetConstraintConstantsToZero(animated: false)
            isOpen = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetAppearanceIfNeeded()
    }
    
}

