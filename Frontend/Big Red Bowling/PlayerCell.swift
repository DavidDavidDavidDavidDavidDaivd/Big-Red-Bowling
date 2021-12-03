//
//  PlayerCell.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/15/21.
//

import UIKit

class PlayerCell: UITableViewCell {
    //Class subViews
    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let currentFrameLabel = UILabel()
    private let arrowView = UIImageView()
    private let lineView = UIView()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       backgroundColor = .white
        
        //nameLabel properties
        nameLabel.font = .systemFont(ofSize: 40, weight: .bold)
        nameLabel.textColor = .black
        
        //scoreLabel properties
        scoreLabel.font = .systemFont(ofSize: 36, weight: .regular)
        scoreLabel.textColor = .black
        
        //currentFrameLabel properties
        currentFrameLabel.font = .systemFont(ofSize: 20, weight: .thin)
        currentFrameLabel.textColor = .black
        
        //arrowView properties
        arrowView.image = UIImage(systemName: "chevron.right", withConfiguration:
                                    UIImage.SymbolConfiguration(weight: .thin))
        arrowView.tintColor = .lightGray
        
        //lineView properties
        lineView.backgroundColor = cornellRed
        
        
        //initialize subviews
        let labelSubView = [nameLabel, scoreLabel, currentFrameLabel, arrowView, lineView]
        labelSubView.forEach { subView in
            contentView.addSubview(subView)
        }
        setupConstraints()
    }
    
    func configureCell(player: Player) {
        //Configure cell with player data
        nameLabel.text = player.name
        let frames = [player.frame1, player.frame2, player.frame3, player.frame4, player.frame5,
                      player.frame6, player.frame7, player.frame8, player.frame9, player.frame10]
        var currentScore = 0
        for frame in frames {
            if frame.score > currentScore {
                currentScore = frame.score
            }
        }
        scoreLabel.text = String(currentScore)
        let currentFrame = findCurrentFrame(player: player)
        if currentFrame == -1 {
            currentFrameLabel.text = "Game Finished"
        } else {
            currentFrameLabel.text = "On frame \(currentFrame)"
        }
    }
    
    func setupConstraints() {
        //Setup Constraints
        nameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(contentView.bounds.width / 12)
            make.centerY.equalToSuperview()
        }
        arrowView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-contentView.bounds.width / 20)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(20)
        }
        scoreLabel.snp.makeConstraints{ make in
            make.trailing.equalTo(arrowView.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
        currentFrameLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-contentView.bounds.width / 12)
            make.bottom.equalToSuperview().offset(-contentView.bounds.height / 8)
        }
        lineView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
