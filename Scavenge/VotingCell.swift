//
//  VotingCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/6/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

class VotingCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let numPlayers = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()

        scrollView.delegate = self
        self.setupUIScrollView()
        self.setupUIPageControl()
    }
    
    func setupUIScrollView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let imageViewWidth = screenSize.width - 16
        let imageViewHeight = imageViewWidth * 8 / 7
        let scrollViewWidth = (imageViewWidth * CGFloat(numPlayers)) + (8 * CGFloat(numPlayers))
        scrollView.contentSize = CGSizeMake(scrollViewWidth, imageViewHeight)
        scrollView.scrollsToTop = true
        
        let imageViewTopic1 = UIImageView(frame: CGRectMake(0, 0, imageViewWidth, imageViewHeight))
        imageViewTopic1.contentMode = .ScaleAspectFill
        imageViewTopic1.image = UIImage(named: "aliya")
        
        var x: CGFloat = 0
        let y: CGFloat = 0
        
        for _ in 0 ..< numPlayers {
            let imageViewTopic = UIImageView(frame: CGRectMake(x, y, imageViewWidth, imageViewHeight))
            imageViewTopic.contentMode = .ScaleAspectFill
            imageViewTopic.image = UIImage(named: "aliya")
            x += (imageViewWidth + 8)
            scrollView.addSubview(imageViewTopic)
        }
    }
    
    // Mark: - UIScrollViewDelegate
    func setupUIPageControl() {
        pageControl.numberOfPages = numPlayers
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.blackColor()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
