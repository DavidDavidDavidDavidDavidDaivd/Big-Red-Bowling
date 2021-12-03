//
//  UserDefaults.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/30/21.
//

import Foundation

let userDefaults = UserDefaults.standard

func updateDefaults() {
    userDefaults.set(localGameIDs, forKey: "gameIDs")
    userDefaults.set(userName, forKey: "userName")
}

func getUserGames() -> [Int] {
   return (userDefaults.array(forKey: "gameIDs") ?? []) as! [Int]
}

func getUserName() -> String {
    return (userDefaults.string(forKey: "userName") ?? "Player")
}

//Initial default instantiation
var localGameIDs: [Int] = getUserGames()
var userName: String = getUserName()
