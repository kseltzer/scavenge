//
//  VotingCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/6/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit

protocol VotingCellDelegate {
    func updateScrollPositionForIndexPath(scrollPosition: CGFloat, index: Int)
    func updateVoteForImageAtIndexPath(_ image: UIImage?, index: Int)
    func hasVotedAtIndexPath(_ index: Int) -> Bool
}

class VotingCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var scrollPosition : CGPoint = CGPoint(x: 0, y: 0)
    var index: Int!
    var delegate : VotingCellDelegate!
    
    let numPlayers = 3 // TODO: get data from backend
    var images: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()

        scrollView.delegate = self
        self.setupUIScrollView()
        self.setupUIPageControl()
    }
    
    func setupUIScrollView() {
        let screenSize: CGRect = UIScreen.main.bounds
        let leadingSpace : CGFloat = 8, trailingSpace : CGFloat = 8
        let imageViewWidth = screenSize.width - (leadingSpace + trailingSpace)
        let imageViewHeight = imageViewWidth * IMAGE_RATIO
        let scrollViewWidth = (imageViewWidth * CGFloat(numPlayers)) + (leadingSpace * CGFloat(numPlayers))
        scrollView.contentSize = CGSize(width: scrollViewWidth, height: imageViewHeight)
        scrollView.scrollsToTop = true
                
        var x: CGFloat = 0
        let y: CGFloat = 0
        
        for i in 0 ..< numPlayers {
            let imageViewTopic = UIImageView(frame: CGRect(x: x, y: y, width: imageViewWidth, height: imageViewHeight))
            imageViewTopic.contentMode = .scaleAspectFill
            imageViewTopic.clipsToBounds = true
            imageViewTopic.image = dummyContentImagesFromBackend[i]
            imageViewTopic.isUserInteractionEnabled = true
            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            imageViewTopic.addGestureRecognizer(doubleTapGestureRecognizer)
            x += (imageViewWidth + trailingSpace)
            scrollView.addSubview(imageViewTopic)
        }
    }
    
    // Mark: - Double Tap To Vote
    func updateUIForVotingState() {
        if (delegate.hasVotedAtIndexPath(index)) {
            setVotedUI()
        } else {
            setNotVotedUI()
        }
    }
    
    func setVotedUI() {
        scrollView.alpha = 0.7
        scrollView.isScrollEnabled = false
    }
    
    func setNotVotedUI() {
        scrollView.alpha = 1.0
        scrollView.isScrollEnabled = true
    }
    
    func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("voted!")
        if (scrollView.isScrollEnabled) {                                     // vote
            setVotedUI()
            delegate.updateVoteForImageAtIndexPath(images[pageControl.currentPage], index: index)
        }
        else {                                                                // cancel vote
            setNotVotedUI()
            delegate.updateVoteForImageAtIndexPath(nil, index: index)
        }
    }
    
    // Mark: - UIScrollViewDelegate
    func setupUIPageControl() {
        pageControl.numberOfPages = numPlayers
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.black
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        scrollPosition = scrollView.contentOffset
        delegate.updateScrollPositionForIndexPath(scrollPosition: scrollPosition.x, index: index)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
}
