//
//  AddPlayerViewController.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/15/21.
//

import Foundation
import SnapKit
import UIKit

class AddPlayerViewController: UIViewController {
    //initialize with game
    var game: Game
    private let delegate: GameViewController
    init(game: Game, delegate: GameViewController) {
        self.game = game
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
   
    }
    
    //subviews
    let addPlayerLabel = UILabel()
    let addPlayerField = UITextField()
    let addPlayerButton = UIButton()
    let cancelButton = UIButton()
    
    let defaultFieldText = "Enter player name"
    let padding = CGFloat(36)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundGray
        
        //add label
        addPlayerLabel.text = "Add a Player"
        addPlayerLabel.font = .systemFont(ofSize: 36, weight: .bold)
        
        //add field
        addPlayerField.text = defaultFieldText
        addPlayerField.clearsOnBeginEditing = true
        addPlayerField.returnKeyType = .done
        addPlayerField.textAlignment = .center
        addPlayerField.backgroundColor = .white
        addPlayerField.textColor = .gray
        addPlayerField.font = .systemFont(ofSize: 28)
        addPlayerField.layer.cornerRadius = 10
        addPlayerField.addTarget(self, action: #selector(fieldModified), for: .allEditingEvents)
        addPlayerField.addTarget(self, action: #selector(stopEditing), for: .primaryActionTriggered)
        
        //add button
        addPlayerButton.setTitle("Add Player", for: .normal)
        addPlayerButton.backgroundColor = .gray
        addPlayerButton.setTitleColor(.black, for: .normal)
        addPlayerButton.layer.cornerRadius = 10
        addPlayerButton.isEnabled = false
        addPlayerButton.addTarget(self, action: #selector(addPlayer), for: .touchDown)
        
        
        //Cancel button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(cornellRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAdd), for: .touchDown)
        
        let subViews = [addPlayerField, addPlayerLabel, addPlayerButton, cancelButton]
        for subView in subViews {
            view.addSubview(subView)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        addPlayerLabel.snp.makeConstraints {make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.bounds.height/10)
        }
        addPlayerField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.top.equalTo(addPlayerLabel.snp.bottom).offset(10)
            make.height.equalTo(60)
        }
        addPlayerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(addPlayerField.snp.bottom).offset(padding/2)
            make.width.equalTo(view.bounds.width/2)
            make.height.equalTo(40)
        }
        cancelButton.snp.makeConstraints {make in
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(20)
        }
    }
    
    @objc func fieldModified(field: UITextField) {
        if field.text == defaultFieldText || field.text == ""
            || field.text!.count > 14 {
            field.textColor = .gray
            addPlayerButton.isEnabled = false
            addPlayerButton.backgroundColor = .gray
        } else {
            field.textColor = cornellRed
            addPlayerButton.isEnabled = true
            addPlayerButton.backgroundColor = cornellRed
        }
    }
    
    @objc func stopEditing(field: UITextField) {
        view.endEditing(true)
        if field.text == "" {
            field.text = defaultFieldText
            addPlayerButton.isEnabled = false
            addPlayerButton.backgroundColor = .gray
        }
    }
    
    @objc func cancelAdd() {
        dismiss(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addPlayer(){
        if addPlayerButton.isEnabled == true {
            NetworkManager.addPlayer(vc: self, gameID: game.gameID, playerName: addPlayerField.text!) { player in
                self.delegate.game.players.append(player)
//                print(self.game.players.count)
                self.delegate.refreshPlayers()
                self.dismiss(animated: true)
            }
        }
    }
    
}
