//
//  Frame.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/14/21.
//

import Foundation

class Frame: Codable {
    var firstRoll: [Int]
    var secondRoll: [Int]
    var thirdRoll: [Int]
    var score: Int
    var mutable: Bool
}
struct frameResponse: Codable{
    var data: Frame
}

//Test Frame Objects
//var tFrame1 = Frame(firstRoll: [1,2,3,4,5, 6, 7, 8], secondRoll: [9], thirdRoll: [-1], score: 9, mutable: false)
//var tFrame2 = Frame(firstRoll: [1,2,3,4,5,6,7,8,9,10], secondRoll: [], thirdRoll: [-1], score: 29, mutable: true)
//var tFrame3 = Frame(firstRoll: [1,2,3,4, 5], secondRoll: [6,7,8,9,10], thirdRoll: [-1], score: 43, mutable: true)
//var tFrame4 = Frame(firstRoll: [1, 2, 3, 4], secondRoll: [5, 6], thirdRoll: [-1], score: 49, mutable: true)
//var tFrame5 = Frame(firstRoll: [1,2,3,4,5,6,7,8,9,10], secondRoll: [], thirdRoll: [-1], score: 72, mutable: true)
//var tFrame6 = Frame(firstRoll: [1,2,3,4,5,6,7,8,9,10], secondRoll: [], thirdRoll: [-1], score: 88, mutable: true)
//var tFrame7 = Frame(firstRoll: [1,2,3], secondRoll: [4,5,6], thirdRoll: [-1], score: 94, mutable: true)
//var tFrame8 = Frame(firstRoll: [2,5,3], secondRoll: [1], thirdRoll: [-1], score: 98, mutable: true)
//var tFrame9 = Frame(firstRoll: [1], secondRoll: [4], thirdRoll: [-1], score: 100, mutable: true)
//var tFrame10 = Frame(firstRoll: [1,2,3,4,5,6,7,8,9,10], secondRoll: [], thirdRoll: [], score: 110, mutable: true)
