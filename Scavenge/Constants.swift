//
//  Constants.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 7/10/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Image Constants
let IMAGE_CELL_BACKGROUND = "cellBackground"
let IMAGE_CELL_BACKGROUND_SELECTED = "cellBackgroundChecked"

// MARK: - Colors
let COLOR_LIGHT_BROWN = UIColor(red:0.83, green:0.60, blue:0.41, alpha:1.0) /* #D39869 */
let COLOR_DARK_BROWN = UIColor(red:0.30, green:0.18, blue:0.12, alpha:1.0) /* #4D2E1E */
let COLOR_DARK_BROWN_DISABLED = UIColor(red:0.30, green:0.18, blue:0.12, alpha:0.5) /* #4D2E1E */
let COLOR_RED = UIColor(red: 223/255, green: 87/255, blue: 100/255, alpha: 1.0) /* #df5764 */
let COLOR_GREENISH_BLUE = UIColor(red: 87/255, green: 223/255, blue: 210/255, alpha: 1.0) /* #57DFD2 */

// todo todo todo (these are old colors)
let COLOR_ORANGE = UIColor(red: 234/255, green: 117/255, blue: 10/255, alpha: 1.0) /* #ea750a */
let COLOR_YELLOW = UIColor(red:1.00, green:0.81, blue:0.40, alpha:1.0)

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

// MARK: - Font Constants
let FONT_BUTTON = UIFont(name: "LithosPro-Black", size: 17.0)
let FONT_LABEL = UIFont(name: "CoquetteBold", size: 17.0)

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
let NAVIGATION_BAR_TINT_COLOR = COLOR_DARK_BROWN
let NAVIGATION_BAR_TEXT_COLOR = UIColor.white
let NAVIGATION_BAR_FONT = UIFont(name: "CoquetteBold", size: 25.0)

// MARK: - Button Constants
let BUTTON_DEFAULT_BACKGROUND_COLOR = COLOR_RED
let BUTTON_FACEBOOK_BACKGROUND_COLOR = UIColor(red: 30/255.0, green: 136/255.0, blue: 229/255.0, alpha: 1.0)
let BUTTON_TEXT_COLOR_NORMAL = UIColor(red: 243/255.0, green: 243/255.0, blue: 243/255.0, alpha: 1.0)
let BUTTON_TEXT_COLOR_DISABLED = UIColor.lightGray
let BUTTON_TEXT_FONT = UIFont(name: "LithosPro-Black", size: 18.0)
let BAR_BUTTON_TEXT_COLOR = UIColor.white

// MARK: - Table View Constants
let TABLE_VIEW_SECTION_FONT = UIFont(name: "CoquetteBold", size: 22.0)
let TABLE_VIEW_SUBSECTION_FONT = UIFont(name: "CoquetteBold", size: 16.0)

let VOTING_TABLE_VIEW_SECTION_FONT = UIFont(name: "CoquetteBold", size: 20.0)
let RESULTS_TABLE_VIEW_SECTION_FONT = UIFont(name: "CoquetteBold", size: 18.0)
let RESULTS_TABLE_VIEW_SUBSECTION_FONT = UIFont(name: "CoquetteBold", size: 12.0)
let RESULTS_TABLE_VIEW_SECTION_HEIGHT : CGFloat = 28

let kSectionTitleInvites = "Invites"
let kSectionTitleResults = "Results"
let kSectionTitleActiveGames = "Active Games"
let kSubsectionTitleYourMove = "Your Move"
let kSubsectionTitleTheirMove = "Their Move"
let kSectionTitleCompletedGames = "Completed Games"

let kSectionTitleRecents = "Recents"
let kSectionTitleFriendsOnScavenge = "Friends"
let kSectionTitleFriendsNotOnScavenge = "Invite"

// MARK: - Font Constants
let FONT_STANDARD_TEXT = UIFont(name: "CoquetteBold", size: 19.0)
let FONT_STANDARD_TEXT_LIGHT = UIFont(name: "CoquetteBold", size: 17.0)

// MARK: - Menu Customization
let MENU_OPTION_TEXT_DEFAULT_COLOR = UIColor.groupTableViewBackground
let MENU_OPTION_TEXT_CURRENT_SCREEN_COLOR = UIColor.lightGray

// MARK: - Cell Customization
let CELL_SELECTED_COLOR = UIColor(red: 218/255, green: 223/255, blue: 225/255, alpha: 1.0)
let CELL_HIGHLIGHTED_COLOR = UIColor(red: 218/255, green: 223/255, blue: 225/255, alpha: 1.0)
let CELL_DEFAULT_COLOR = COLOR_LIGHT_BROWN
let CELL_BORDER_COLOR_DEFAULT = UIColor(red:0.87, green:0.62, blue:0.42, alpha:1.0) /* #DD9E6B */
let CELL_BORDER_COLOR_SELECTED = UIColor(red:0.70, green:0.45, blue:0.30, alpha:1.0) /* #B3734D */

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
