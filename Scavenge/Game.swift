//
//  Game.swift
//  Scavenge
//
//  Created by Kimberly Seltzer on 12/27/16.
//  Copyright © 2016 Kim Seltzer. All rights reserved.
//

import Foundation
import UIKit

enum GameStatus: String {
    case invite = "invite"
    case results = "results"
    case yourMove = "yourMove"
    case theirMove = "theirMove"
    case completed = "completed"
}

enum GameSubtitle: String {
    case invite
    case results
    case yourPlay
    case yourVote
    case theirPlay
    case theirVote
    case completed
}

struct Game {
    var id: String
    var title: String
    var icon: UIImage? = nil // Todo: change to URL
    var creator: Player? = nil
    var status: GameStatus = .yourMove
    var subtitle: String = ""
    var players: [Player] = []
    var unsubmittedResponses: [String:[UIImage?]] // Todo: change UIImage to URL
    var winner: Player? = nil
    var results: [TopicResults] = []
    var topics: [String] = []
    var numPlayers: Int {
        return players.count
    }
    
    init(id: String, title: String, topics: [String]) {
        self.id = id
        self.title = title
        self.topics = topics
        
        var unsubmittedResponses: [String:[UIImage?]] = [:]
        for player in players {
            unsubmittedResponses[player.id] = [nil, nil, nil, nil, nil]
        }
        self.unsubmittedResponses = unsubmittedResponses
    }
    
    init(id: String, title: String, icon: UIImage /* todo: change to Int */, creator: Player, status: GameStatus, subtitle: GameSubtitle, players: [Player] = []) {
        self.id = id
        self.title = title
        self.icon = icon
        self.creator = creator
        self.status = status
        self.subtitle = getSubtitleString(subtitle: subtitle)
        self.players = players
        
        var unsubmittedResponses: [String:[UIImage?]] = [:]
        for player in players {
            unsubmittedResponses[player.id] = [nil, nil, nil, nil, nil]
        }
        self.unsubmittedResponses = unsubmittedResponses
    }
    
    init(id: String, title: String, icon: UIImage /* todo: change to URL */, creator: Player, status: GameStatus, players: [Player], winner: Player?, results: [TopicResults], topics: [String], subtitle: GameSubtitle) {
        self.id = id
        self.title = title
        self.icon = icon
        self.creator = creator
        self.status = status
        self.players = players
        self.winner = winner
        self.results = results
        self.topics = topics
        self.subtitle = getSubtitleString(subtitle: subtitle)

        var unsubmittedResponses: [String:[UIImage?]] = [:]
        for player in players {
            unsubmittedResponses[player.id] = [nil, nil, nil, nil, nil]
        }
        self.unsubmittedResponses = unsubmittedResponses
    }
}

func getSubtitleString(subtitle: GameSubtitle, creator: Player? = nil, winner: Player? = nil) -> String {
    switch(subtitle) {
    case .invite:
        if let creator = creator {
            return "INVITED BY \(creator.name)"
        }
        break
    case .yourPlay:
        return "IT'S YOUR TURN TO PLAY"
    case .yourVote:
        return "YOU GOTTA VOTE"
    case .theirPlay:
        return "WAITING FOR YOUR FRIENDS TO PLAY"
    case .theirVote:
        return "YOUR FRIENDS HAVEN'T VOTED YET"
    case .completed:
        if let winner = winner {
            return "\(winner.name) WON THIS GAME"
        }
        break
    default:
        break
    }
    return ""
}

