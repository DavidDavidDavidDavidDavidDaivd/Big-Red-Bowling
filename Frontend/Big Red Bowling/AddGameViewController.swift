//
//  AddGameViewController.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/15/21.
//

import Foundation
import SnapKit
import UIKit

class AddGameViewController: UIViewController {
    let delegate: ViewController
    init(delegate: ViewController) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    //SubViews
    private let gameNameField = UITextField()
    private let gameIDField = UITextField()
    private let joinGameButton = UIButton()
    private let createGameButton = UIButton()
    private let createGameLabel = UILabel()
    private let joinGameLabel = UILabel()
    private let errorMessageLabel = UILabel()
    private let cancelButton = UIButton()

    private let padding = CGFloat(36)
    private let defaultNameTitle = "Enter a game name"
    private let defaultIDTitle = "Enter game ID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundGray
        
        //create game Label
        createGameLabel.text = "Create a Game"
        createGameLabel.font = .systemFont(ofSize: 36, weight: .bold)
        
        //join game label
        joinGameLabel.text = "Join a Friend"
        joinGameLabel.font = createGameLabel.font
        
        //gameField
        gameNameField.text = defaultNameTitle
        
        //ID Field
        gameIDField.text = defaultIDTitle
        gameIDField.keyboardType = .numbersAndPunctuation
        
        //Join game button
        joinGameButton.setTitle("Join Game", for: .normal)

        //Create game button
        createGameButton.setTitle("Create Game", for: .normal)
        
        //Cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(cornellRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAdd), for: .touchDown)
        
        //configure fields
        let textFields = [gameIDField, gameNameField]
        for field in textFields {
            field.clearsOnBeginEditing = true
            field.returnKeyType = .done
            field.textAlignment = .center
            field.backgroundColor = .white
            field.textColor = .gray
            field.font = .systemFont(ofSize: 28)
            field.layer.cornerRadius = 10
            field.addTarget(self, action: #selector(fieldModified), for: .allEditingEvents)
            field.addTarget(self, action: #selector(stopEditing), for: .primaryActionTriggered)
        }
        
        //configure Buttons
        let buttons = [joinGameButton, createGameButton]
        for button in buttons {
            button.backgroundColor = .gray
            button.setTitleColor(.black, for: .normal)
            button.layer.cornerRadius = 10
            button.isEnabled = false
            button.addTarget(self, action: #selector(startGame), for: .touchDown)
        }
        //add subviews
        let subViews = [createGameLabel, joinGameLabel, gameNameField, gameIDField,
                        joinGameButton, createGameButton, cancelButton]
        for subView in subViews {
            view.addSubview(subView)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        createGameLabel.snp.makeConstraints {make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.bounds.height/10)
        }
        gameNameField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.top.equalTo(createGameLabel.snp.bottom).offset(10)
            make.height.equalTo(60)
        }
        createGameButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(gameNameField.snp.bottom).offset(padding/2)
            make.width.equalTo(view.bounds.width/2)
            make.height.equalTo(40)
        }
        joinGameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(createGameButton.snp.bottom).offset(20)
        }
        gameIDField.snp.makeConstraints { make in
            make.top.equalTo(joinGameLabel.snp.bottom).offset(10)
            make.leading.equalTo(gameNameField.snp.leading)
            make.trailing.equalTo(gameNameField.snp.trailing)
            make.height.equalTo(gameNameField.snp.height)
        }
        joinGameButton.snp.makeConstraints { make in
            make.top.equalTo(gameIDField.snp.bottom).offset(padding/2)
            make.centerX.equalToSuperview()
            make.height.equalTo(createGameButton.snp.height)
            make.width.equalTo(createGameButton.snp.width)
        }
        cancelButton.snp.makeConstraints {make in
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(20)
        }
    }
    
    @objc func startGame(button: UIButton) {
        //Joins game with ID in ID field
        if button == joinGameButton {
            if joinGameButton.isEnabled == true {
                NetworkManager.getGame(vc: self, gameID: Int(gameIDField.text!) ?? 0) { game in
                    localGameIDs.append(game.gameID)
                    var playerExists = false
                    for player in game.players {
                        if player.name == userName {
                            print("player exists")
                            playerExists = true
                        }
                    }
                    if !playerExists {
                        NetworkManager.addPlayer(vc: self, gameID: game.gameID, playerName: userName) { player in
                            return
                        }
                    }
                    self.delegate.refreshGames()
                    self.dismiss(animated: true)
                }
            }
        }
        if button == createGameButton {
            //Creates game with name in name Field
            if createGameButton.isEnabled == true {
                NetworkManager.createGame(vc: self, Gamename: gameNameField.text ?? "") { game in
                    localGameIDs.append(game.gameID)
                    NetworkManager.addPlayer(vc: self, gameID: game.gameID, playerName: userName){ player in
                    }
                    self.delegate.refreshGames()
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @objc func fieldModified(field: UITextField) {
        //field actions while typing
        if field == gameNameField {
            if field.text == defaultNameTitle || field.text == ""
                || field.text!.count > 14 {
                field.textColor = .gray
                createGameButton.isEnabled = false
                createGameButton.backgroundColor = .gray
            } else {
                field.textColor = cornellRed
                createGameButton.isEnabled = true
                createGameButton.backgroundColor = cornellRed
            }
        }
        if field == gameIDField {
            if field.text == defaultIDTitle || field.text == ""
                //check for digits only. Credit: https://stackoverflow.com/users/5219866/cristina-de-rito
                || !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: field.text!)) {
                field.textColor = .gray
                joinGameButton.isEnabled = false
                joinGameButton.backgroundColor = .gray
            } else {
                field.textColor = cornellRed
                joinGameButton.isEnabled = true
                joinGameButton.backgroundColor = cornellRed
            }
        }
    }
    
    @objc func stopEditing(field: UITextField) {
        view.endEditing(true)
        if field.text == "" {
            if field == gameNameField {
                field.text = defaultNameTitle
                createGameButton.isEnabled = false
                createGameButton.backgroundColor = .gray
            }
            if field == gameIDField {
                field.text = defaultIDTitle
                joinGameButton.isEnabled = false
                joinGameButton.backgroundColor = .gray
            }
        }
    }
    
    @objc func cancelAdd() {
        dismiss(animated: true)
    }
    
    required init?(coder: NSCoder) {
        //IGNORE< ME
        fatalError("init(coder:) has not been implemented")
    }
}
