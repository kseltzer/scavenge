//
//  Constants.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit
// dark brown: 157,77,71
// light brown: 211,171,136
// yellow: 255,206,101

// MARK: - Colors
let COLOR_LIGHT_BROWN = UIColor(red: 216/255, green: 185/255, blue: 131/255, alpha: 1.0) /* #D8B983 */
let COLOR_DARK_BROWN = UIColor(red: 211/255, green: 171/255, blue: 136/255, alpha: 1.0)
let COLOR_ORANGE = UIColor(red: 234/255, green: 117/255, blue: 10/255, alpha: 1.0) /* #ea750a */
let COLOR_RED = UIColor(red: 223/255, green: 87/255, blue: 100/255, alpha: 1.0) /* #df5764 */
let COLOR_YELLOW = UIColor(red:1.00, green:0.81, blue:0.40, alpha:1.0)
let COLOR_GREEN = UIColor(red: 87/255, green: 223/255, blue: 210/255, alpha: 1.0) /* greenish-blue */

// MARK: - Game Play Constants
let NUM_GAME_QUESTIONS = 5
let IMAGE_RATIO : CGFloat = 8 / 7
let MAX_PLAYERS : Int = 6

// MARK: - Session Constants
let KEY_ID = "id"
let KEY_ACCESS_TOKEN = "access_token"
let KEY_FIRST_NAME = "first_name"
let KEY_LAST_NAME = "last_name"

// MARK: - Session Variables
var userProfileImage: UIImage? = nil
var currentUserID: String = ""
var currentUserAccessToken: String = ""

// MARK: - Storyboard Constants
let kLoginStoryboard = "LoginStoryboard"
let kMainStoryboard = "MainStoryboard"
let kCreateGameStoryboard = "CreateGameStoryboard"
let kPlayingGameStoryboard = "PlayingGameStoryboard"

// MARK: - View Controller Constants
let kLoginViewController = "LoginViewController"
let kHomeViewController = "HomeViewController"
let kCreateGameViewController = "CreateGameViewController"
let kPlayingGameViewController = "PlayingGameViewController"
let kSNavigationController = "SNavigationController"
let kGameResultsViewController = "ResultsViewController"
let kVotingViewController = "VotingViewController"
let kGameSummaryViewController = "GameSummaryViewController"

// MARK: - Segue Constants
let kShowMenuSegue = "showMenu"

// MARK: - Navigation Bar Constants
let NAVIGATION_BAR_TINT_COLOR = UIColor.black
let NAVIGATION_BAR_TEXT_COLOR = UIColor.black
let NAVIGATION_BAR_FONT = UIFont(name: "Avenir-Black", size: 26.0)

// MARK: - Button Constants
let BUTTON_DEFAULT_BACKGROUND_COLOR = COLOR_RED
let BUTTON_FACEBOOK_BACKGROUND_COLOR = UIColor(red: 30/255.0, green: 136/255.0, blue: 229/255.0, alpha: 1.0)
let BUTTON_TEXT_COLOR_NORMAL = UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
let BUTTON_TEXT_COLOR_DISABLED = UIColor.lightGray
let BUTTON_TEXT_FONT = UIFont(name: "AvenirNext-Bold", size: 18.0)
let BAR_BUTTON_TEXT_COLOR = UIColor.black

// MARK: - Table View Constants
let TABLE_VIEW_SECTION_FONT = UIFont(name: "AvenirNext-Heavy", size: 22.0)
let TABLE_VIEW_SUBSECTION_FONT = UIFont(name: "AvenirNext-Heavy", size: 16.0)

let VOTING_TABLE_VIEW_SECTION_FONT = UIFont(name: "AvenirNext-Heavy", size: 20.0)
let RESULTS_TABLE_VIEW_SECTION_FONT = UIFont(name: "AvenirNext-Heavy", size: 18.0)
let RESULTS_TABLE_VIEW_SUBSECTION_FONT = UIFont(name: "AvenirNext-Bold", size: 12.0)
let RESULTS_TABLE_VIEW_SECTION_HEIGHT : CGFloat = 28

let kSectionTitleInvites = "INVITES"
let kSectionTitleResults = "RESULTS"
let kSectionTitleActiveGames = "ACTIVE GAMES"
let kSubsectionTitleYourMove = "your move"
let kSubsectionTitleTheirMove = "their move"
let kSectionTitleCompletedGames = "COMPLETED GAMES"

let kSectionTitleRecents = "RECENTS"
let kSectionTitleFriendsOnScavenge = "FRIENDS"
let kSectionTitleFriendsNotOnScavenge = "INVITE"

// MARK: - Font Constants
let FONT_STANDARD_TEXT = UIFont(name: "Avenir-Black", size: 17.0)
let FONT_STANDARD_TEXT_LIGHT = UIFont(name: "AvenirNext-Medium", size: 17.0)

// MARK: - Menu Customization
let MENU_OPTION_TEXT_DEFAULT_COLOR = UIColor.groupTableViewBackground
let MENU_OPTION_TEXT_CURRENT_SCREEN_COLOR = UIColor.lightGray

// MARK: - Cell Customization
let CELL_SELECTED_COLOR = UIColor(red: 218/255, green: 223/255, blue: 225/255, alpha: 1.0)
let CELL_HIGHLIGHTED_COLOR = UIColor(red: 218/255, green: 223/255, blue: 225/255, alpha: 1.0)
let CELL_DEFAULT_COLOR = COLOR_LIGHT_BROWN

let CELL_DEFAULT_COLOR_HOME = COLOR_LIGHT_BROWN

let kFriendCellIdentifier = "friendCell"

// MARK: - String Constants
let kErrorTitle = "oops!"
let kAcceptFaultErrorMessage = "my bad"

// MARK: - Screen Size Constants
let iPHONE_5: CGFloat = 320.0
let iPHONE_5S: CGFloat = 320.0
let iPHONE_6: CGFloat = 375.0
let iPHONE_6_PLUS: CGFloat = 414.0
let iPHONE_6S: CGFloat = 375.0
let iPHONE_7: CGFloat = 375.0
let iPHONE_7_PLUS: CGFloat = 414.0
let iPHONE_7S: CGFloat = 375.0
let iPHONE_SE: CGFloat = 320.0

// MARK: - JSON Parsing Constants
let JSON_KEY_RECENTS = "recents"
let JSON_KEY_FRIENDS = "friends"
let JSON_KEY_FIRST_NAME = "firstName"
let JSON_KEY_NAME = "name"
let JSON_KEY_PROFILE_IMAGE = "profileImage"
let JSON_KEY_ID = "id"
let JSON_KEY_TITLE = "title"
let JSON_KEY_TOPICS = "topics"

// MARK: - Image Constants
let kNegativeStateProfileImageKim = "negativeStateKim"
let kNegativeStateProfileImageAliya = "negativeStateAliya"
let kNegativeStateProfileImageAC = "negativeStateAC"
let kNegativeStateProfileImageSachin = "negativeStateSachin"
let kNegativeStateProfileImageIan = "negativeStateIan"

let kFlashOnButtonImageName = "flashOnButton"
let kFlashOffButtonImageName = "flashOffButton"
let kFlashAutoButtonImageName = "flashAutoButton"
