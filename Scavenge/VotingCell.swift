//
//  VotingCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/6/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

protocol VotingCellDelegate {
    func updateScrollPositionForIndexPath(scrollPosition scrollPosition: CGFloat, index: Int)
}

class VotingCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var scrollPosition : CGPoint = CGPointMake(0, 0)
    var index: Int!
    var delegate : VotingCellDelegate!
    
    let numPlayers = 3 // TODO: get data from backend
    
    override func awakeFromNib() {
        super.awakeFromNib()

        scrollView.delegate = self
        self.setupUIScrollView()
        self.setupUIPageControl()
    }
    
    func setupUIScrollView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let leadingSpace : CGFloat = 8, trailingSpace : CGFloat = 8
        let imageViewWidth = screenSize.width - (leadingSpace + trailingSpace)
        let imageViewHeight = imageViewWidth * IMAGE_RATIO
        let scrollViewWidth = (imageViewWidth * CGFloat(numPlayers)) + (leadingSpace * CGFloat(numPlayers))
        scrollView.contentSize = CGSizeMake(scrollViewWidth, imageViewHeight)
        scrollView.scrollsToTop = true
                
        var x: CGFloat = 0
        let y: CGFloat = 0
        
        for _ in 0 ..< numPlayers {
            let imageViewTopic = UIImageView(frame: CGRectMake(x, y, imageViewWidth, imageViewHeight))
            imageViewTopic.contentMode = .ScaleAspectFill
            imageViewTopic.image = UIImage(named: "aliya")
            x += (imageViewWidth + trailingSpace)
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
        scrollPosition = scrollView.contentOffset
        delegate.updateScrollPositionForIndexPath(scrollPosition: scrollPosition.x, index: index)
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
