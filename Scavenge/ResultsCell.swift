//
//  ResultsCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/31/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

protocol ResultsCellDelegate {
    func updateScrollPositionForIndexPath(scrollPosition: CGFloat, index: Int)
}

class ResultsCell: UITableViewCell, UIScrollViewDelegate {
    
    let numPlayers = 5 // TODO: get data from backend

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollPosition : CGPoint = CGPoint(x: 0, y: 0)
    var index: Int!
    var delegate : ResultsCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.delegate = self

        self.setupUIScrollView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupUIScrollView() {
        let screenSize: CGRect = UIScreen.main.bounds
        let leadingSpace : CGFloat = 8, trailingSpace : CGFloat = 8
        let imageViewWidth = (screenSize.width - (leadingSpace + trailingSpace)) / 2.5
        let imageViewHeight = imageViewWidth * IMAGE_RATIO
        let scrollViewWidth = (imageViewWidth * CGFloat(numPlayers)) + (8 * CGFloat(numPlayers))
        scrollView.contentSize = CGSize(width: scrollViewWidth, height: imageViewHeight)
        scrollView.scrollsToTop = true
        
        var x: CGFloat = 0
        let y: CGFloat = 0
        
        for _ in 0 ..< numPlayers {
            let imageViewTopic = UIImageView(frame: CGRect(x: x, y: y, width: imageViewWidth, height: imageViewHeight))
            imageViewTopic.contentMode = .scaleAspectFill
            let photoSubmission = UIImage(named: "aliya") // TODO: get data from backend
            imageViewTopic.image = photoSubmission
            scrollView.addSubview(imageViewTopic)
            
            let playerLabel = UILabel(frame: CGRect(x: x, y: y + imageViewHeight + 16, width: imageViewWidth, height: 20))
            let submittedBy = "Kim Seltzer" // TODO: get data from backend
            playerLabel.text = "by: \(submittedBy)"
            playerLabel.font = RESULTS_TABLE_VIEW_SUBSECTION_FONT
            scrollView.addSubview(playerLabel)
            
            let votesLabel = UILabel(frame: CGRect(x: x + 4, y: y, width: imageViewWidth, height: 20))
            let numVotes = 3 // TODO: get data from backend
            votesLabel.text = "\(numVotes) votes"
            votesLabel.font = TABLE_VIEW_SUBSECTION_FONT
            scrollView.addSubview(votesLabel)
            
            x += (imageViewWidth + 8)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollPosition = scrollView.contentOffset
        delegate.updateScrollPositionForIndexPath(scrollPosition: scrollPosition.x, index: index)
    }
}
