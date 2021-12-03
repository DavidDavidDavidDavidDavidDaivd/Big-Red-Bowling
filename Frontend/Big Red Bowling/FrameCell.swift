//
//  FrameCell.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/20/21.
//

import UIKit

class FrameCell: UITableViewCell {
    //subviews
    let frameName = UILabel()
    let rollLabel1 = UILabel()
    let rollLabel2 = UILabel()
    let rollLabel3 = UILabel()
    let scoreLabel = UILabel()
    let frameImage = UIImageView()
    
    let frameBuffer = CGFloat(3)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        //frame name
        frameName.font = .systemFont(ofSize: 34, weight: .bold)
        
        //scoreLabel
        scoreLabel.font = .systemFont(ofSize: 28)
        
        //frameImage
        frameImage.contentMode = .scaleAspectFit
        frameImage.image = UIImage(named: "bowlingFrame")
        
        //roll labels
        let rollLabels = [rollLabel1, rollLabel2, rollLabel3]
        for label in rollLabels {
            label.font = .systemFont(ofSize: 15)
            contentView.addSubview(label)
        }
        //setup subviews
        let subViews = [frameName, scoreLabel, frameImage]
        for subView in subViews {
            contentView.addSubview(subView)
        }
        setupConstraints()
    }
    
    func configureCell(frame: Frame, frameNumber: Int, player: Player) {
        //configure cell data
        //frame number text
        frameName.text = "Frame \(frameNumber)"
        //frame score
        let frameScore = frame.score
        if frameScore != -1 {
//            print("Score in frame \(frameNumber) is \(frameScore)")
            scoreLabel.text = String(frameScore)
        } else {
            scoreLabel.text = ""
        }
        if frameNumber == 10 {
            frameImage.image = UIImage(named: "bowlingFrame10")
        } else {
            frameImage.image = UIImage(named: "bowlingFrame")
        }
        //Assign the rollLabel text
        let rolls = [frame.firstRoll, frame.secondRoll, frame.thirdRoll]
        let rollLabels = [rollLabel1, rollLabel2, rollLabel3]
        if frameNumber != 10 {
            if isStrike(currentFrame: frame) {
//                print("Frame \(frame) is a strike")
                rollLabel1.text = ""
                rollLabel2.text = "X"
                rollLabel3.text = ""
            } else if isSpare(currentFrame: frame) {
                rollLabel1.text = String(frame.firstRoll.count)
                rollLabel2.text = "⁄ "
                rollLabel3.text = ""
            } else {
                for roll in 0...2 {
                    if rolls[roll] == [-1] {
                        rollLabels[roll].text = ""
                    } else {
                        rollLabels[roll].text = String(rolls[roll].count)
                        }
                }
            }
            //tenth frame lol
        } else {
//            print("Tenth frame")
            if frame.firstRoll != [-1] {
                if frame.firstRoll.count == 10 {
                    rollLabel3.text = "X"
                } else {
                    rollLabel3.text = String(frame.firstRoll.count)
                }
            }
            else {
                rollLabel3.text = ""
            }
            if frame.secondRoll != [-1]{
                if frame.secondRoll.count == 10 {
                    rollLabel1.text = "X"
                }
                else if frame.firstRoll.count + frame.secondRoll.count == 10 {
                    rollLabel1.text = "⁄ "
                }
                else {
                    rollLabel1.text = String(frame.secondRoll.count)
                }
            }
            else {
                rollLabel1.text = ""
            }
            if frame.thirdRoll != [-1] {
                if frame.thirdRoll.count == 10 {
                    rollLabel2.text = "X"
                }
                else if frame.firstRoll.count == 10 && frame.secondRoll.count + frame.thirdRoll.count == 10 {
                    rollLabel2.text = "⁄ "
                }
                else {
                    rollLabel2.text = String(frame.thirdRoll.count)
                }
            }
            else {
                rollLabel2.text = ""
            }
//                rollLabel2.text = ""
//            }
//            if isStrike(currentFrame: frame) {
//                rollLabel3.text = "X"
//                if frame.secondRoll != [-1] {
//                    if frame.secondRoll.count == 10{
//                        rollLabel1.text = "X"
//                    } else {
//                        rollLabel1.text = String(frame.secondRoll.count)
//                    }
//                } else {
//                    rollLabel1.text = ""
//                }
//            } else if frame.secondRoll != [-1] {
//                if isSpare(currentFrame: frame) {
//                    rollLabel3.text = String(frame.firstRoll.count)
//                    rollLabel2.text = "⁄ "
//                }
//            } else {
//                if frame.firstRoll != [-1] {
//                    rollLabel3.text = String(frame.firstRoll.count)
//                    if frame.secondRoll != [-1] {
//                        rollLabel1.text = String(frame.secondRoll.count)
//                    } else {
//                        rollLabel1.text = ""
//                    }
//                } else {
//                    rollLabel1.text = ""
//                    rollLabel3.text = ""
//                }
//            }
        }
    }
    
    func setupConstraints() {
        //numbers are all constrained by the frame image
        frameName.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(contentView.bounds.width/8)
            make.centerY.equalToSuperview()
        }
        frameImage.snp.makeConstraints {make in
            make.height.equalTo(80)
            make.width.equalTo(80)
            make.trailing.equalTo(-contentView.bounds.width/8)
            make.centerY.equalToSuperview()
        }
        scoreLabel.snp.makeConstraints { make in
            make.centerX.equalTo(frameImage.snp.centerX)
            make.centerY.equalToSuperview().offset(4)
        }
        rollLabel1.snp.makeConstraints { make in
            make.centerX.equalTo(frameImage.snp.centerX)
            make.top.equalTo(frameImage.snp.top).offset(frameBuffer)
        }
        rollLabel2.snp.makeConstraints { make in
            make.trailing.equalTo(frameImage.snp.trailing).offset(-frameBuffer*3)
            make.top.equalTo(frameImage.snp.top).offset(frameBuffer)
        }
        rollLabel3.snp.makeConstraints {make in
            make.leading.equalTo(frameImage.snp.leading).offset(frameBuffer*3)
            make.top.equalTo(frameImage.snp.top).offset(frameBuffer)
        }
    }
    
    required init?(coder: NSCoder) {
        //IGNORE ME
        fatalError("init(coder:) has not been implemented")
    }
}
