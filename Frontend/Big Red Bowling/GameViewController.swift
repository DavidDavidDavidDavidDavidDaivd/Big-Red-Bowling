//
//  GameViewController.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/14/21.
//

import Foundation
import SnapKit
import UIKit

class GameViewController: UIViewController {
    //MARK: Class Vars
    //Class vars
    var game: Game
    private let playerReuseID = "playerReuseID"
    init(game: Game) {
        //Initialize with game
        self.game = game
//        self.game.players.sort(by: <)
        super.init(nibName: nil, bundle: nil)
    }
    
    //Main Views
    private let playerTableView = UITableView()
    private let bottomMargin = UIView()
    private let highestScoreLabel = UILabel()
    private let lineView = UIView()
    
    //Navigation bar view
    private let addPlayerButton = UIBarButtonItem()
    
    //Refresh action
    private let playerRefreshControl = UIRefreshControl()
    
    //MARK: View Did Load
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshPlayers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load view
        view.backgroundColor = backgroundGray
        title = game.name
        
        
        //Setup playerTableView
        playerTableView.backgroundColor = .clear
        playerTableView.separatorColor = .clear
        playerTableView.dataSource = self
        playerTableView.delegate = self
        playerTableView.register(PlayerCell.self, forCellReuseIdentifier: playerReuseID)
        playerTableView.tableHeaderView = lineView
        playerTableView.refreshControl = playerRefreshControl

        
        //Refresh Control
        playerRefreshControl.addTarget(self, action: #selector(refreshPlayers), for: .valueChanged)
        
        //headerLine properties
        lineView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 4)
        lineView.backgroundColor = cornellRed
        
        //Setup bottomMargin
        bottomMargin.backgroundColor = cornellRed
//        bottomMargin.backgroundColor = .clear
        
        //Setup highestScoreLabel
        setHighestScorer()
        
        
        highestScoreLabel.font = .systemFont(ofSize: 28, weight: .regular)
        highestScoreLabel.textColor = .white
        
        //Navigation info button
        addPlayerButton.image = UIImage(systemName: "plus")
        addPlayerButton.target = self
        addPlayerButton.action = #selector(addPlayer)
        
        //Setup subviews
        let subViews = [playerTableView, bottomMargin, highestScoreLabel]
        subViews.forEach { subView in
            view.addSubview(subView)
        }
        self.navigationItem.rightBarButtonItem = addPlayerButton
        setupConstraints()
    }
    
    func setupConstraints() {
        //Setup subview constraints
        bottomMargin.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(view.bounds.height / 10)
        }
        playerTableView.snp.makeConstraints { make in
            make.bottom.equalTo(bottomMargin.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        highestScoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomMargin.snp.centerY)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func refreshPlayers() {
        //Refreshes the player list with new data
//        print(game.players.count)
        NetworkManager.getGame(vc: self, gameID: game.gameID) { game in
            self.game = game
//            self.game.players.sort(by: <)
            self.setHighestScorer()
            self.playerTableView.reloadData()
            self.playerRefreshControl.endRefreshing()
        }
    }
    
    @objc func addPlayer() {
        let vc = AddPlayerViewController(game: game, delegate: self)
        present(vc, animated: true, completion: nil)
    }
    
    func setHighestScorer() {
        if let highestScorer = findTopScorer(game: game) {
            if highestScorer.score != -1 {
                highestScoreLabel.text = "Highest Score: \(highestScorer.score), \(highestScorer.name)"
            } else {
                highestScoreLabel.text = "Highest Score: 0, \(highestScorer.name)"
            }
        } else {
            highestScoreLabel.text = "Highest Score: None"}
    }
    
    required init?(coder: NSCoder) {
        //Ignore this
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: TableView Delegation
extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("Number of players in game is \(game.players.count)")
        NetworkManager.getGame(vc: self, gameID: game.gameID) { game in
            self.game = game
        }
//        print(game.players.count)
        return game.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let playerCell = playerTableView.dequeueReusableCell(withIdentifier: playerReuseID, for: indexPath)
            as? PlayerCell {
            playerCell.configureCell(player: game.players[indexPath.row])
            playerCell.selectionStyle = .none
//            print("Returning Player Cell")
            return playerCell
        } else {
//            print("Returning generic player cell")
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Swipe action to delete
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            
            NetworkManager.deletePlayer(vc: self, gameID: self.game.gameID, playerName: self.game.players[indexPath.row].name) { player in
                return
            }
            self.game.players.remove(at: indexPath.row)
            self.playerTableView.reloadData()
            
            self.playerTableView.reloadData()
            completion(true)
        }
        deleteButton.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
}

extension GameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return playerTableView.bounds.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerViewController(game: game, player: game.players[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
