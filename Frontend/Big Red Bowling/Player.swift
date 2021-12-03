//
//  Player.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/14/21.
//

import Foundation

struct Player: Codable & Comparable {
    static func < (lhs: Player, rhs: Player) -> Bool {
        return lhs.name < rhs.name
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name: String
    var frame1: Frame
    var frame2: Frame
    var frame3: Frame
    var frame4: Frame
    var frame5: Frame
    var frame6: Frame
    var frame7: Frame
    var frame8: Frame
    var frame9: Frame
    var frame10: Frame
    var score: Int
}
struct PlayerResponse: Codable{
    var data: Player
}
struct DeletePlayerResponse: Codable{
    var success: Bool
}

//Test Player Objects
//var testPlayer1 = Player(name: "Sally", frame1: tFrame1, frame2: tFrame2, frame3: tFrame3, frame4: tFrame4, frame5: tFrame5, frame6: tFrame6, frame7: tFrame7, frame8: tFrame8, frame9: tFrame9, frame10: tFrame10, score: 110)

