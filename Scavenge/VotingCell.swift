//
//  VotingCell.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 8/6/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import UIKit
import WVCheckMark

protocol VotingCellDelegate {
    func updateScrollPositionForIndexPath(scrollPosition: CGFloat, index: Int)
    func updateVoteForImageAtIndexPath(_ image: UIImage?, index: Int)
    func hasVotedAtIndexPath(_ index: Int) -> Bool
}

class VotingCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var checkmarkAnimationView: WVCheckMark!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var cellBackgroundImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    
    var scrollPosition : CGPoint = CGPoint(x: 0, y: 0)
    var index: Int!
    var delegate : VotingCellDelegate!
    
    let numPlayers = 3 // TODO: get data from backend
    var images: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()

        cellBackgroundImageView.layer.borderColor = CELL_BORDER_COLOR_DEFAULT.cgColor
        cellBackgroundImageView.layer.borderWidth = 8
        
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
        let y: CGFloat = 16
        
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
    
    func setVotedUI(animated: Bool = false) {
        scrollView.isScrollEnabled = false
        
        // make cell look disabled
        overlayView.alpha = 0.5
        
        // show checkmark
        checkmarkAnimationView.isHidden = false
        checkmarkAnimationView.backgroundColor = UIColor.clear
        checkmarkAnimationView.setColor(color: COLOR_GREEN_VOTE_CHECKMARK.cgColor)
        checkmarkAnimationView.setLineWidth(width: 6.0)
        
        if (animated) {
            checkmarkAnimationView.setDuration(speed: 0.7)
            checkmarkAnimationView.start()
        } else {
            checkmarkAnimationView.setDuration(speed: 0)
            checkmarkAnimationView.start()
        }
        
        pageControl.currentPageIndicatorTintColor = COLOR_GREEN_VOTE_CHECKMARK
    }
    
    func setNotVotedUI() {
        overlayView.alpha = 0.0
        checkmarkAnimationView.isHidden = true
        scrollView.isScrollEnabled = true
        pageControl.currentPageIndicatorTintColor = COLOR_ORANGE
    }
    
    func imageTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        print("voted!")
        if (scrollView.isScrollEnabled) {                                     // vote
            setVotedUI(animated: true)
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
        pageControl.currentPageIndicatorTintColor = COLOR_ORANGE
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
