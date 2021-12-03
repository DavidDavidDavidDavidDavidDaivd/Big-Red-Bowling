//
//  GameCell.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/14/21.
//

import UIKit
import SnapKit

class GameCell: UITableViewCell {
    //Cell Items
    private let gameNameLabel = UILabel()
    private let playerCountLabel = UILabel()
//    private let dateLabel = UILabel()
    private let winnerLabel = UILabel()
    private let idLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        //gameIDLabel properties
        gameNameLabel.font = .systemFont(ofSize: 40, weight: .bold)
        gameNameLabel.textColor = cornellRed
        
        //playerCountLabel properties
        playerCountLabel.font = .systemFont(ofSize: 24)
        playerCountLabel.textColor = .black
        
        //setup idLabel
        idLabel.font = .systemFont(ofSize: 18)
        idLabel.textColor = .black
        
        //create subviews
        let subViews = [gameNameLabel, playerCountLabel, idLabel]
        subViews.forEach { subView in
            contentView.addSubview(subView)
        }
        setupConstraints()
        
    }
    
    func setupGameCell(game: Game) {
        //Data to display on the cell
        gameNameLabel.text = game.name
        idLabel.text = "ID: \(game.gameID)"
        if game.players.count != 1 {
            playerCountLabel.text = "\(game.players.count) Players"
        } else {
            playerCountLabel.text = "\(game.players.count) Player"
        }
    }
    
    func setupConstraints() {
        //Constraints of cell items
        gameNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(contentView.bounds.width/8)
            make.top.equalToSuperview().offset(contentView.bounds.height/3)
        }
        playerCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(gameNameLabel.snp.leading)
            make.top.equalTo(gameNameLabel.snp.bottom)
        }
        idLabel.snp.makeConstraints { make in
            make .trailing.equalToSuperview().offset(-contentView.bounds.width/8)
            make.bottom.equalToSuperview().offset(-contentView.bounds.height/3)
        }
    }
    
    //Ignore
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
