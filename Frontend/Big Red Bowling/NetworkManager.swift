//
//  NetworkManager.swift
//  Big Red Bowling
//
//  Created by Berk Gokmen on 11/15/21.
//

import Foundation
import Alamofire
class NetworkManager {
    
//    static let endpoint = "https://davidbertuch.pythonanywhere.com/api"
//    static let endpoint = "http://127.0.0.1:5000/api"
    static let endpoint = "https://bigredbowling.herokuapp.com/api"
    
    static func createGame(vc: UIViewController, Gamename: String, completion: @escaping (Game) -> Void){
        //POST Method
        //Creates game with GameID and Name. Automatically assigns isComplete and Date
        //Returns Game
        let parameters: [String: String] = [
            "name": Gamename
        ]
        
        AF.request("\(endpoint)/games/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
//            print(response.debugDescription)
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let gameResponse = try? jsonDecoder.decode(GameResponse.self, from: data) {
                    let game = gameResponse.data
                    completion(game)
                }
            case .failure(_):
                alertError(delegate: vc, type: .lostConnection)
            }
        }
    }
    
    static func getGame(vc: UIViewController, gameID: Int, completion: @escaping (Game) -> Void ) {
        //GET Method
        //Returns Game with given gameID
        //If gameid not valid, returns error
        AF.request("\(endpoint)/games/\(gameID)/").validate().responseData { response in
//            print(response.debugDescription)
            let jsonDecoder = JSONDecoder()
            switch response.result {
            case .success(let data):
                if let gameResponse = try? jsonDecoder.decode(GameResponse.self, from: data) {
                    var game = gameResponse.data
                    game.players.sort()
                    completion(game)
                }
            case .failure(_):
                if let data = response.data {
                    if let _ = try? jsonDecoder.decode(ErrorResponse.self, from: data) {
                        alertError(delegate: vc, type: .invalidID)
                    }
                } else {
                    alertError(delegate: vc, type: .lostConnection)
                }
            }
        }
    }
    
    static func addPlayer(vc: UIViewController, gameID: Int, playerName: String, completion: @escaping (Player) -> Void) {
        //POST Method
        //Creates player with given Name inside the given gameid and modifies JSON
        let parameters: [String: Any] = [
            "name": playerName,
            "gameID": gameID
        ]
        AF.request("\(endpoint)/players/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            let jsonDecoder = JSONDecoder()
            switch response.result {
            case .success(let data):
//                print(response.debugDescription)
                if let playerResponse = try? jsonDecoder.decode(PlayerResponse.self, from: data) {
//                    print("sucess")
                    let player = playerResponse.data
                    completion(player)
                }
            case .failure(_):
                if let data = response.data {
                    if let _ = try? jsonDecoder.decode(ErrorResponse.self, from: data) {
                        alertError(delegate: vc, type: .duplicatePlayerName)
                    }
                } else {
                    alertError(delegate: vc, type: .lostConnection)
                }
            }
        }
    }
    
    static func deletePlayer(vc: UIViewController, gameID: Int, playerName: String, completion: @escaping (Bool) -> Void) {
        //DEL Method
        //Deletes player with given name in a given game and removes from JSon, returns true if sucessful
        
        let parameters: [String: String] = [
            "name": playerName
        ]
        
        AF.request("\(endpoint)/games/\(gameID)/", method: .delete, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let playerResponse = try? jsonDecoder.decode(DeletePlayerResponse.self, from: data) {
                    let success = playerResponse.success
                    completion(success)
                }
            case .failure(_):
                alertError(delegate: vc, type: .lostConnection)
            }
        }
    }
    
    static func postFrame(vc: UIViewController, gameID: Int, playerName: String, frameName: String, firstRoll: [Int], secondRoll: [Int], thirdRoll: [Int], score: Int, completion: @escaping (Frame) -> Void) {
        let parameters: [String: Any] = [
            "gameID": gameID,
            "name": playerName,
            "frameName": frameName,
            "firstRoll": firstRoll,
            "secondRoll": secondRoll,
            "thirdRoll": thirdRoll,
            "score": score,
            "mutable": true
        ]
        
//        print("entered network")
        AF.request("\(endpoint)/frames/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
//            print(response.debugDescription)
            switch response.result {
            case .success(let data):
//                print(response.debugDescription)
                let jsonDecoder = JSONDecoder()
                if let frameResponse = try? jsonDecoder.decode(frameResponse.self, from: data) {
//                    print("in here")
                    let frame = frameResponse.data
//                    print(frame.firstRoll)
                    completion(frame)
                }
            case .failure(_):
                alertError(delegate: vc, type: .lostConnection)
            }
        }
    }
}

