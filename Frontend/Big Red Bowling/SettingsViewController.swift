//
//  SettingsViewController.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/15/21.
//

import Foundation
import SnapKit
import UIKit

class SettingsViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    let nameLabel = UILabel()
    let nameField = UITextField()
    let saveButton = UIButton()
    let cancelButton = UIButton()
    
    let defaultFieldText = userName
    let padding = CGFloat(36)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundGray
        
        nameLabel.text = "Name"
        nameLabel.font = .systemFont(ofSize: 36, weight: .bold)
        
        //add field
        nameField.text = defaultFieldText
        nameField.clearsOnBeginEditing = true
        nameField.returnKeyType = .done
        nameField.textAlignment = .center
        nameField.backgroundColor = .white
        nameField.textColor = cornellRed
        nameField.font = .systemFont(ofSize: 28)
        nameField.layer.cornerRadius = 10
        nameField.addTarget(self, action: #selector(fieldModified), for: .allEditingEvents)
        nameField.addTarget(self, action: #selector(stopEditing), for: .primaryActionTriggered)
        
        //Save button
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(cornellRed, for: .normal)
        saveButton.addTarget(self, action: #selector(saveName), for: .touchDown)
        
        //Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(cornellRed, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchDown)

        
        
        let subViews = [nameLabel, nameField, saveButton, cancelButton]
        for subView in subViews{
            view.addSubview(subView)
        }
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupConstraints() {
        nameLabel.snp.makeConstraints {make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.bounds.height/10)
        }
        nameField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(60)
        }
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-25)
            make.top.equalToSuperview().offset(20)
        }
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalTo(saveButton)
        }
    }
    
    @objc func fieldModified(field: UITextField) {
        //field actions while typing
        if field.text == "" || field.text!.count > 14 {
            field.textColor = .gray
            saveButton.isEnabled = false
        }
        else {
            field.textColor = cornellRed
            saveButton.isEnabled = true
        }
    }
    
    @objc func stopEditing(field: UITextField) {
        //Action when done button is pressed
        view.endEditing(true)
        if nameField.text == "" {
            nameField.text = defaultFieldText
            saveButton.isEnabled = false
            nameField.textColor = cornellRed
        }
    }
    
    @objc func saveName() {
        if saveButton.isEnabled {
            userName = nameField.text ?? "Player"
            updateDefaults()
            dismiss(animated: true)
        }
    }
    
    @objc func cancelAction() {
        dismiss(animated: true)
    }
}
