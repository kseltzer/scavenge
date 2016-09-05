//
//  ResultsCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/31/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

protocol ResultsCellDelegate {
    func updateScrollPositionForIndexPath(scrollPosition scrollPosition: CGFloat, index: Int)
}

class ResultsCell: UITableViewCell, UIScrollViewDelegate {
    
    let numPlayers = 5 // TODO: hard coded data

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollPosition : CGPoint = CGPointMake(0, 0)
    
    var index: Int!
    
    var delegate : ResultsCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.delegate = self

        self.setupUIScrollView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupUIScrollView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let imageViewWidth = (screenSize.width - 16) / 2.5
        let imageViewHeight = imageViewWidth * (8 / 7)
        let scrollViewWidth = (imageViewWidth * CGFloat(numPlayers)) + (8 * CGFloat(numPlayers))
        scrollView.contentSize = CGSizeMake(scrollViewWidth, imageViewHeight)
        scrollView.scrollsToTop = true
        
        var x: CGFloat = 0
        let y: CGFloat = 0
        
        for _ in 0 ..< numPlayers {
            let imageViewTopic = UIImageView(frame: CGRectMake(x, y, imageViewWidth, imageViewHeight))
            imageViewTopic.contentMode = .ScaleAspectFill
            imageViewTopic.image = UIImage(named: "aliya")
            scrollView.addSubview(imageViewTopic)
            
            let votesLabel = UILabel(frame: CGRectMake(x, y + imageViewHeight + 16, imageViewWidth, 20))
            votesLabel.text = "Kim Seltzer"  // TODO: hard coded data
            votesLabel.font = TABLE_VIEW_SUBSECTION_FONT
            scrollView.addSubview(votesLabel)
            
            let playerLabel = UILabel(frame: CGRectMake(x + 4, y, imageViewWidth, 20))
            playerLabel.text = "3 votes" // TODO: hard coded data
            playerLabel.font = TABLE_VIEW_SUBSECTION_FONT
            scrollView.addSubview(playerLabel)
            
            x += (imageViewWidth + 8)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollPosition = scrollView.contentOffset
        delegate.updateScrollPositionForIndexPath(scrollPosition: scrollPosition.x, index: index)
    }
}
