//
//  gameFunctions.swift
//  Big Red Bowling
//
//  Created by Berk Gokmen on 11/16/21.
//
import Foundation
import UIKit

//    func updateScore(currentPlayer: Player, playerName: String, frameName: String, firstRoll: [Int], secondRoll: [Int], thirdRoll:[Int], score: Int) -> Frame{
//        //Updates score on the server and updates frame locally. by posting frame data to the server. Returns the frame retrieved from server
//        var frameObject = Frame(firstRoll: [-1], secondRoll: [-1], thirdRoll: [-1], score: 0, mutable: false)
//        NetworkManager.postFrame(playerName: playerName, frameName: frameName, firstRoll: firstRoll, secondRoll: secondRoll, thirdRoll: thirdRoll, score: score) {frame in
//            frameObject = frame
//            
//        }
//        return frameObject
//    }

    
func findCurrentFrame(player: Player) -> Int {
    //Returns the frame that the player is currently on. -1 if the player has finished
    let frames = [player.frame1, player.frame2, player.frame3, player.frame4, player.frame5,
                  player.frame6, player.frame7, player.frame8, player.frame9, player.frame10]
    for frameIndex in 0...8 {
        if frames[frameIndex].secondRoll == [-1] {
            return frameIndex + 1
        }
    }
    if player.frame10.firstRoll.count + player.frame10.secondRoll.count >= 10 && player.frame10.thirdRoll == [-1]{
        return 10
    } else if player.frame10.secondRoll == [-1] {
        return 10
    } else {
        return -1
    }
}

func findTopScorer(game: Game) -> Player? {
    if game.players.count > 0 {
        var highestScorer = game.players[0]
        for player in game.players {
            if player.score > highestScorer.score{
                highestScorer = player
            }
            if player.frame10.score > highestScorer.score {
                highestScorer = player
            }
        }
        return highestScorer
    } else {
        return nil
    }
}

func isStrike(currentFrame: Frame) -> Bool{
    //returns true if the currentFrame is a strike. Else, returns false. DOES NOT APPLY TO LAST FRAME
    let firstRollCount = currentFrame.firstRoll.count
    return firstRollCount == 10
}
func isSpare(currentFrame: Frame) -> Bool{
//returns true if the currentFrame is a spare. Else, returns false.
    if isStrike(currentFrame: currentFrame) {
        return false
    }
    if currentFrame.secondRoll == [-1] {
        return false
    }
    let firstSecondRollCount = currentFrame.firstRoll.count + currentFrame.secondRoll.count
    return firstSecondRollCount == 10
}
func getNextRoll(currentPlayer: Player, frameNumber: Int, roll: Int) -> [Int]{
    //Returns the first roll of the next frame. frameNumber is an int representation of the frame. FrameNumber must be less than 10.

    let responseMessages = ["Frame1": currentPlayer.frame1, "Frame2": currentPlayer.frame2, "Frame3": currentPlayer.frame3, "Frame4": currentPlayer.frame4, "Frame5": currentPlayer.frame5, "Frame6": currentPlayer.frame6, "Frame7": currentPlayer.frame7, "Frame8": currentPlayer.frame8, "Frame9": currentPlayer.frame9, "Frame10": currentPlayer.frame10]
                        
    let currentFrame = responseMessages["Frame\(String(frameNumber))"]!
    if isStrike(currentFrame: currentFrame)  {
        //if current frame is a strike or spare, return the first roll of the next frame
        return responseMessages["Frame\(String(frameNumber + 1))"]!.firstRoll
    }
    else {
        if roll == 1{
                return currentFrame.secondRoll
        }
        if roll == 2{
            return responseMessages["Frame\(String(frameNumber + 1))"]!.firstRoll
        }
    }
    
    return responseMessages["Frame\(String(frameNumber + 1))"]!.firstRoll
}
func scoreCalculator(currentPlayer: Player, frameNumber: Int) -> Int {
    //returns the score of the provided frame number. Returns and int value. If frame is empty, returns -1. Returns the score up to that frame
    
//    print("score calculator called with framenumber \(String(frameNumber))")
    
    let responseMessages = ["Frame1": currentPlayer.frame1, "Frame2": currentPlayer.frame2, "Frame3": currentPlayer.frame3, "Frame4": currentPlayer.frame4, "Frame5": currentPlayer.frame5, "Frame6": currentPlayer.frame6, "Frame7": currentPlayer.frame7, "Frame8": currentPlayer.frame8, "Frame9": currentPlayer.frame9, "Frame10": currentPlayer.frame10]
    let currentFrame = responseMessages["Frame\(String(frameNumber))"]!
    if frameNumber == 1{
        if !isSpare(currentFrame: currentFrame) && !isStrike(currentFrame: currentFrame) {
            if currentFrame.firstRoll == [-1] || currentFrame.secondRoll == [-1]{
//                print(currentFrame.firstRoll)
                return -1
          
            }
            else {
//                print("Not spare or strike. Return \(String(currentFrame.firstRoll.count)) and \(String(currentFrame.secondRoll.count)) ")
                return currentFrame.firstRoll.count + currentFrame.secondRoll.count
            }
            
    }
        if isSpare(currentFrame: currentFrame){
            if getNextRoll(currentPlayer: currentPlayer, frameNumber: 1, roll: 2) == [-1]{
                return -1
            }
            else {
                return 10 + getNextRoll(currentPlayer: currentPlayer, frameNumber: 1, roll: 2).count
            }
        }
        if isStrike(currentFrame: currentFrame) {
            if getNextRoll(currentPlayer: currentPlayer, frameNumber: 1, roll: 1) == [-1] || getNextRoll(currentPlayer: currentPlayer, frameNumber: 2, roll: 1) == [-1] {
                return -1
            }
            else {
                return 10 + getNextRoll(currentPlayer: currentPlayer, frameNumber: 1, roll: 1).count + getNextRoll(currentPlayer: currentPlayer, frameNumber: 2, roll: 1).count
            }
        }
    }
    else if frameNumber < 10 {
        
        if !isSpare(currentFrame: currentFrame) && !isStrike(currentFrame: currentFrame) {
            if currentFrame.firstRoll == [-1] || currentFrame.secondRoll == [-1] {
                return -1
            }
            else {
                return currentFrame.firstRoll.count + currentFrame.secondRoll.count + responseMessages["Frame\(String(frameNumber - 1))"]!.score
            }
    }
        if isSpare(currentFrame: currentFrame){
            if getNextRoll(currentPlayer: currentPlayer, frameNumber: frameNumber, roll: 2) == [-1] {
                return -1
            }
            else {
                return 10 + getNextRoll(currentPlayer: currentPlayer, frameNumber: frameNumber, roll: 2).count + responseMessages["Frame\(String(frameNumber - 1))"]!.score
            }
        }
        if isStrike(currentFrame: currentFrame) {
            if frameNumber == 8 && isStrike(currentFrame: responseMessages["Frame\(String(frameNumber + 1))"]!) {
                if responseMessages["Frame10"]!.firstRoll != [-1]{
                return responseMessages["Frame\(String(frameNumber - 1))"]!.score + 20 + responseMessages["Frame10"]!.firstRoll.count
                }
            }
            else if frameNumber == 9 {
                if responseMessages["Frame10"]!.firstRoll != [-1] && responseMessages["Frame10"]!.secondRoll != [-1] {
                return responseMessages["Frame\(String(frameNumber - 1))"]!.score + responseMessages["Frame10"]!.firstRoll.count + responseMessages["Frame10"]!.secondRoll.count + 10
            }
            }
            else if getNextRoll(currentPlayer: currentPlayer, frameNumber: frameNumber, roll: 2) == [-1] || getNextRoll(currentPlayer: currentPlayer, frameNumber: frameNumber + 1, roll: 1) == [-1] {
                return -1
            }
            else {
                return 10 + getNextRoll(currentPlayer: currentPlayer, frameNumber: frameNumber, roll: 2).count + getNextRoll(currentPlayer: currentPlayer, frameNumber: frameNumber + 1, roll: 1).count + responseMessages["Frame\(String(frameNumber - 1))"]!.score
            }
        }
    }
    else if frameNumber == 10{
        if currentFrame.firstRoll == [-1] || currentFrame.secondRoll == [-1] {
            return -1
        }
        if currentFrame.thirdRoll == [-1] {
            return currentFrame.firstRoll.count + currentFrame.secondRoll.count + responseMessages["Frame\(String(frameNumber - 1))"]!.score
        }
        if currentFrame.firstRoll.count == 10 {
            return currentFrame.firstRoll.count + currentFrame.secondRoll.count + currentFrame.thirdRoll.count + responseMessages["Frame\(String(frameNumber - 1))"]!.score
        }
        if currentFrame.firstRoll.count < 10 && (currentFrame.firstRoll + currentFrame.secondRoll).count == 10{
            return 10 + currentFrame.thirdRoll.count + responseMessages["Frame\(String(frameNumber - 1))"]!.score
        }
    }
    return -1 //just to have a return since Swift requires it
}


