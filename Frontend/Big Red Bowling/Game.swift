//
//  Game.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/14/21.
//

import Foundation

struct GameResponse: Codable {
    var success: Bool
    var data: Game
}

struct Game: Codable {
    var name: String
    var gameID: Int
    var isComplete: Bool
    var players: [Player]
//    var date: Date
}

//Test game objects
//var testGame1 = Game(name: "My game", gameID: 1234, isComplete: true, players: [testPlayer1])
//var testGame2 = Game(name: "Number 2", gameID: 1233, isComplete: false, players: [testPlayer1,testPlayer1])

//Locally Stored Game List
//var localGameList: [Game] = [testGame1, testGame2]

