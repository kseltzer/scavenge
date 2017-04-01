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

struct Game {
    var id: String
    var title: String
    var icon: UIImage? = nil // Todo: change to URL
    var creator: Player? = nil
    var status: GameStatus = .yourMove
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
    
    init(id: String, title: String, icon: UIImage /* todo: change to URL */, creator: Player, status: GameStatus) {
        self.id = id
        self.title = title
        self.icon = icon
        self.creator = creator
        self.status = status
        
        var unsubmittedResponses: [String:[UIImage?]] = [:]
        for player in players {
            unsubmittedResponses[player.id] = [nil, nil, nil, nil, nil]
        }
        self.unsubmittedResponses = unsubmittedResponses
    }
    
    init(id: String, title: String, icon: UIImage /* todo: change to URL */, creator: Player, status: GameStatus, players: [Player], winner: Player?, results: [TopicResults], topics: [String]) {
        self.id = id
        self.title = title
        self.icon = icon
        self.creator = creator
        self.status = status
        self.players = players
        self.winner = winner
        self.results = results
        self.topics = topics

        var unsubmittedResponses: [String:[UIImage?]] = [:]
        for player in players {
            unsubmittedResponses[player.id] = [nil, nil, nil, nil, nil]
        }
        self.unsubmittedResponses = unsubmittedResponses
    }
}

