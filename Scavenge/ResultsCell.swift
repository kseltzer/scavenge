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
    
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollPosition : CGPoint = CGPoint(x: 0, y: 0)
    var index: Int!
    var delegate : ResultsCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(numPlayers: Int, results: TopicResults) {
        let screenSize: CGRect = UIScreen.main.bounds
        let leadingSpace : CGFloat = 8, trailingSpace : CGFloat = 8
        let playerLabelHeight: CGFloat = 20
        let imageViewWidth = (screenSize.width - (leadingSpace + trailingSpace)) / 2.5
        let imageViewHeight = imageViewWidth * IMAGE_RATIO
        let scrollViewWidth = (imageViewWidth * CGFloat(numPlayers)) + (8 * CGFloat(numPlayers))
        scrollView.contentSize = CGSize(width: scrollViewWidth, height: imageViewHeight)
        scrollView.scrollsToTop = true
        
        var x: CGFloat = 0
        let y: CGFloat = 0

        for index in 0 ..< numPlayers {
            let imageView = UIImageView(frame: CGRect(x: x, y: y, width: imageViewWidth, height: imageViewHeight))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            let submission = results.submissions[index]
            imageView.image = submission.image
            scrollView.addSubview(imageView)
            
            let playerLabel = UILabel(frame: CGRect(x: x, y: y + imageViewHeight, width: imageViewWidth, height: playerLabelHeight))
            playerLabel.text = "by: \(submission.submittedBy.name)"
            playerLabel.font = RESULTS_TABLE_VIEW_SUBSECTION_FONT
            scrollView.addSubview(playerLabel)
            
            var votesLabelBackgroundWidth: CGFloat = 52
            let votesLabel = UILabel(frame: CGRect(x: x + 4, y: y, width: imageViewWidth, height: 20))
            votesLabel.text = "\(submission.numVotes) vote"
            if (submission.numVotes != 1) {
                votesLabel.text = "\(votesLabel.text!)s"
                votesLabelBackgroundWidth = 60
            }
            votesLabel.font = TABLE_VIEW_SUBSECTION_FONT
            
            let votesLabelBackground = UIView(frame: CGRect(x: x, y: y, width: votesLabelBackgroundWidth, height: 20))
            votesLabelBackground.backgroundColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)

            scrollView.addSubview(votesLabelBackground)
            scrollView.addSubview(votesLabel)
            
            x += (imageViewWidth + 8)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollPosition = scrollView.contentOffset
        delegate.updateScrollPositionForIndexPath(scrollPosition: scrollPosition.x, index: index)
    }
}
