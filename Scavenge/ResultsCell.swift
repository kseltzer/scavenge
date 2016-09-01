//
//  ResultsCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/31/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class ResultsCell: UITableViewCell, UIScrollViewDelegate {
    
    let numPlayers = 3 // TODO: - hard coded data

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
            
            let playerLabel = UILabel(frame: CGRectMake(x, y + imageViewHeight + 16, imageViewWidth, 20))
            playerLabel.text = "Kim Seltzer"
            playerLabel.font = TABLE_VIEW_SUBSECTION_FONT
            scrollView.addSubview(playerLabel)
            
            x += (imageViewWidth + 8)
        }
    }

}
