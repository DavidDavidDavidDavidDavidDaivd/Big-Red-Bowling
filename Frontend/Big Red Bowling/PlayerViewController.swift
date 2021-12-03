//
//  PlayerViewController.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/15/21.
//

import UIKit
import SnapKit

class PlayerViewController: UIViewController {
    //Initialize with game and player index
    let game: Game
    var player: Player
    var frames: [Frame]
    var onTenthFrame = false
    var calculateTenthFrame = false
    
    init(game: Game, player: Player) {
        self.game = game
        self.player = player
        self.frames = [player.frame1, player.frame2, player.frame3, player.frame4, player.frame5,
                       player.frame6, player.frame7, player.frame8, player.frame9, player.frame10]
        super.init(nibName: nil, bundle: nil)
    }
    
    //views
    let frameTableView = UITableView()
    let frameReuseID = "frameReuseID"
    
    //constants
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO: Implement refresh function
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = player.name
        view.backgroundColor = backgroundGray

        //frameTableView properties
        frameTableView.delegate = self
        frameTableView.dataSource = self
        frameTableView.register(FrameCell.self, forCellReuseIdentifier: frameReuseID)
        frameTableView.backgroundColor = .clear
        
        //add Subviews
        let subViews = [frameTableView]
        for subView in subViews {
            view.addSubview(subView)
        }
        setupContraints()
    }
    
    func setupContraints() {
        frameTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func updateFrame(frame: Frame){
        //var currentFrame = frames[findCurrentFrame(player: self.player)]
        let currentIndex = findCurrentFrame(player: player) - 1
        if currentIndex < 9 && !onTenthFrame {
            if isStrike(currentFrame: frame){
                frame.secondRoll = []
                frame.score = -1
                frame.mutable = false
            }
            else if frame.secondRoll != [-1] {
                frame.score = scoreCalculator(currentPlayer: player, frameNumber: currentIndex)
                frame.mutable = false
            }
            for index in 0...(currentIndex) {
                frames[index].score = scoreCalculator(currentPlayer: player, frameNumber: index + 1)
                NetworkManager.postFrame(vc: self, gameID: game.gameID, playerName: player.name, frameName: "frame\(index + 1)", firstRoll: frames[index].firstRoll, secondRoll: frames[index].secondRoll, thirdRoll: frames[index].thirdRoll, score: frames[index].score) { _ in
                    return
                }
                
            }
        }
        else {
            onTenthFrame = true
            frames[7].score = scoreCalculator(currentPlayer: player, frameNumber: 8)
            NetworkManager.postFrame(vc: self, gameID: game.gameID, playerName: player.name, frameName: "frame8", firstRoll: frame.firstRoll, secondRoll: frames[7].secondRoll, thirdRoll: frames[7].thirdRoll, score: frames[7].score) { _ in
                return
            }

            if frames[8].firstRoll.count + frames[8].secondRoll.count == 10 {
                frames[8].score = scoreCalculator(currentPlayer: player, frameNumber: 9)
                NetworkManager.postFrame(vc: self, gameID: game.gameID, playerName: player.name, frameName: "frame9", firstRoll: frames[8].firstRoll, secondRoll: frames[8].secondRoll, thirdRoll: frames[8].thirdRoll, score: frames[8].score) { _ in
                    return
                }
            }
            if frames[9].secondRoll != [-1]{
                frames[8].score = scoreCalculator(currentPlayer: player, frameNumber: 9)
                NetworkManager.postFrame(vc: self, gameID: game.gameID, playerName: player.name, frameName: "frame9", firstRoll: frames[8].firstRoll, secondRoll: frames[8].secondRoll, thirdRoll: frames[8].thirdRoll, score: frames[8].score) { _ in
                    return
                }
            }
            if frame.firstRoll.count == 10 || frame.secondRoll.count == 10 || frame.firstRoll.count + frame.secondRoll.count == 10  {
                if frame.thirdRoll != [-1] {
//                    print("printing here")
                    frame.mutable = false
                    calculateTenthFrame = true
                }
            }
            else if frame.firstRoll.count + frame.secondRoll.count < 10{
                if frame.thirdRoll == [-1] {
                    if frame.firstRoll.count + frame.secondRoll.count == 10 {
                        frame.mutable = false
                        calculateTenthFrame = true
                    }
                }
//                print(frame.firstRoll.count + frame.secondRoll.count)
                if frame.secondRoll != [-1] {
//                    print("no, here!")
                    frame.mutable = false
                    calculateTenthFrame = true
                }
            }
//            print("First roll is")
//            print(frame.firstRoll)
//            print("Second roll is")
//            print(frame.secondRoll)
//            print("third roll is")
//            print(frame.thirdRoll)
            if calculateTenthFrame {
                frames[9].score = scoreCalculator(currentPlayer: player, frameNumber: 10)
                NetworkManager.postFrame(vc: self, gameID: game.gameID, playerName: player.name, frameName: "frame10", firstRoll: frames[9].firstRoll, secondRoll: frames[9].secondRoll, thirdRoll: frames[9].thirdRoll, score: frames[9].score) { _ in
                    return
                }
            }
        }
        frameTableView.reloadData()
    }
    
    
    required init?(coder: NSCoder) {
        //Ignore me:(
            fatalError("init(coder:) has not been implemented")
        }
}

extension PlayerViewController: UITableViewDataSource {
    //Lists only the active frame and previous frames.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentFrame = findCurrentFrame(player: player)
        if currentFrame == -1 {
            return 10
        } else {
            return currentFrame
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Configure each cell with frame data based on table index
        if let frameCell = frameTableView.dequeueReusableCell(withIdentifier: frameReuseID, for: indexPath)
            as? FrameCell {
            frameCell.configureCell(frame: frames[indexPath.row], frameNumber: indexPath.row+1,
                                    player: player)
            frameCell.selectionStyle = .none
            return frameCell
        } else {
            return UITableViewCell()
        }
    }
}

extension PlayerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FrameViewController(player: self.player, frame: frames[indexPath.row],
                                     delegate: self, currentIndex: indexPath.row + 1)
        present(vc, animated: true, completion: nil)
        
    }
}
