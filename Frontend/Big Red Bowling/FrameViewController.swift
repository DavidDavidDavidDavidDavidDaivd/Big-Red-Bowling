//
//  FrameViewController.swift
//  Big Red Bowling
//
//  Created by Berk Gokmen on 11/30/21.
//

import Foundation
import SnapKit
import UIKit

class FrameViewController: UIViewController {
    //Initialize with game and player index
    var player: Player
    var frame: Frame
    var currentIndex: Int
    private let delegate: PlayerViewController
    var convertDict: [Int:UIButton]
    
    init(player: Player, frame: Frame, delegate: PlayerViewController, currentIndex: Int) {
        self.player = player
        self.frame = frame
        self.delegate = delegate
        self.currentIndex = currentIndex
        self.convertDict = [1: onePinButton, 2: twoPinButton, 3: threePinButton, 4: fourPinButton, 5: fivePinButton ,6: sixPinButton, 7: sevenPinButton, 8: eightPinButton, 9: ninePinButton, 10: tenPinButton]
        super.init(nibName: nil, bundle: nil)
    }
    
    //subviews
    private let onePinButton = UIButton()
    private let twoPinButton = UIButton()
    private let threePinButton = UIButton()
    private let fourPinButton = UIButton()
    private let fivePinButton = UIButton()
    private let sixPinButton = UIButton()
    private let sevenPinButton = UIButton()
    private let eightPinButton = UIButton()
    private let ninePinButton = UIButton()
    private let tenPinButton = UIButton()
    //dummy view for pin alignment
    private let pinBox = UIView()
    
    private let saveButton = UIButton()
    private let specialButton = UIButton()
    private let counterLabel = UILabel()
    
    //class vars
    private var isFirstRoll = true
    private var isThirdRoll = false
    private let imageConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .thin, scale: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundGray
        
        //dismiss button
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        saveButton.layer.cornerRadius = 6
        saveButton.backgroundColor = cornellRed
        saveButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        
        //dummy view
        pinBox.backgroundColor = .clear
        
        //counter
        counterLabel.font = .systemFont(ofSize: 32, weight: .bold)
        counterLabel.text = "0 Pins"
        counterLabel.backgroundColor = .clear
        
        //special Button
        specialButton.backgroundColor = cornellRed
        specialButton.addTarget(self, action: #selector(specialFunction), for: .touchUpInside)
        specialButton.setTitleColor(.white, for: .normal)
        specialButton.layer.cornerRadius = 6
        specialButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        if currentIndex < 10 {
            if frame.secondRoll != [-1] {
                specialButton.isEnabled = false
                specialButton.setTitle("", for: .disabled)
                counterLabel.text = "Frame Complete"
                saveButton.isEnabled = false
                saveButton.setTitle("", for: .normal)
                saveButton.backgroundColor = .clear
                specialButton.backgroundColor = .clear
            }
            else if frame.firstRoll == [-1] {
                specialButton.setTitle("Strike", for: .normal)
            } else {
                specialButton.setTitle("Spare", for: .normal)
            }
        } else {
            if frame.firstRoll == [-1] {
                specialButton.setTitle("Strike", for: .normal)
            }
            else if frame.secondRoll == [-1] {
                if frame.firstRoll.count == 10 {
                    specialButton.setTitle("Strike", for: .normal)
                } else {
                    specialButton.setTitle("Spare", for: .normal)
                }
            } else {
                if frame.thirdRoll != [-1] {
                    specialButton.isEnabled = false
                    specialButton.setTitle("", for: .disabled)
                    counterLabel.text = "Frame Complete"
                    saveButton.isEnabled = false
                    saveButton.setTitle("", for: .normal)
                    saveButton.backgroundColor = .clear
                    specialButton.backgroundColor = .clear
                } else if frame.secondRoll.count == 10 {
                    specialButton.setTitle("Strike", for: .normal)
                } else if frame.firstRoll.count == 10 {
                    specialButton.setTitle("Spare", for: .normal)
                } else if frame.secondRoll.count + frame.firstRoll.count < 10 {
                    specialButton.isEnabled = false
                    specialButton.setTitle("", for: .disabled)
                    counterLabel.text = "Frame Complete"
                    saveButton.isEnabled = false
                    saveButton.setTitle("", for: .normal)
                    saveButton.backgroundColor = .clear
                    specialButton.backgroundColor = .clear
                } else if frame.secondRoll.count + frame.firstRoll.count == 10 {
                    specialButton.setTitle("Strike", for: .normal)
                }
            }
        }
        
        
        //configure pin buttons
        let pinButtons = [onePinButton, twoPinButton, threePinButton, fourPinButton, fivePinButton,
                          sixPinButton, sevenPinButton, eightPinButton, ninePinButton, tenPinButton]
        var imageNumber = 1
        for button in pinButtons {
            button.tintColor = cornellRed
            button.setImage(UIImage(systemName: "\(imageNumber).circle", withConfiguration: imageConfig), for: .normal)
            button.setImage(UIImage(systemName: "\(imageNumber).circle.fill", withConfiguration: imageConfig), for: .selected)
            button.addTarget(self, action: #selector(clicked), for: .touchDown)
            imageNumber += 1
            view.addSubview(button)
        }
        
        let subViews = [saveButton, pinBox, counterLabel, specialButton]
        for subView in subViews {
            view.addSubview(subView)
        }
        view.sendSubviewToBack(pinBox)
        setupConstraints()
        checkRoll()
    }
    func setupConstraints() {
        pinBox.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(pinBox.snp.width)
        }
        //starting form the top left
        let pinSpacing = view.bounds.width/5
        let pinSize = pinSpacing
//        print(heightSpacing)
//        print(pinBox.frame.size.height)
//        print(pinBox.frame.width)
        sevenPinButton.snp.makeConstraints { make in
            make.centerX.equalTo(pinSpacing)
            make.centerY.equalTo(pinSpacing)
            make.size.equalTo(pinSize)
        }
        eightPinButton.snp.makeConstraints { make in
            make.centerX.equalTo(2*pinSpacing)
            make.centerY.equalTo(pinSpacing)
            make.size.equalTo(pinSize)
        }
        ninePinButton.snp.makeConstraints { make in
            make.centerX.equalTo(3*pinSpacing)
            make.centerY.equalTo(pinSpacing)
            make.size.equalTo(pinSize)
        }
        tenPinButton.snp.makeConstraints { make in
            make.centerX.equalTo(4*pinSpacing)
            make.centerY.equalTo(pinSpacing)
            make.size.equalTo(pinSize)
        }
        fourPinButton.snp.makeConstraints { make in
            make.centerX.equalTo(sevenPinButton.snp.centerX).offset(0.5*pinSpacing)
            make.centerY.equalTo(2*pinSpacing)
            make.size.equalTo(pinSize)
        }
        fivePinButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(2*pinSpacing)
            make.size.equalTo(pinSize)
        }
        sixPinButton.snp.makeConstraints { make in
            make.centerX.equalTo(ninePinButton.snp.centerX).offset(0.5*pinSpacing)
            make.centerY.equalTo(2*pinSpacing)
            make.size.equalTo(pinSize)
        }
        twoPinButton.snp.makeConstraints { make in
            make.centerX.equalTo(eightPinButton.snp.centerX)
            make.centerY.equalTo(3*pinSpacing)
            make.size.equalTo(pinSize)
        }
        threePinButton.snp.makeConstraints { make in
            make.centerX.equalTo(ninePinButton.snp.centerX)
            make.centerY.equalTo(3*pinSpacing)
            make.size.equalTo(pinSize)
        }
        onePinButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(4*pinSpacing)
            make.size.equalTo(pinSize)
        }
        counterLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pinBox.snp.bottom).offset(-0.5*pinSpacing)
        }
        specialButton.snp.makeConstraints { make in
            make.trailing.equalTo(onePinButton.snp.leading)
            make.top.equalTo(counterLabel.snp.bottom).offset(0.5*pinSpacing)
            make.height.equalTo(counterLabel.snp.height).offset(0.2*pinSpacing)
            make.width.equalTo(view.bounds.width/3)
        }
        saveButton.snp.makeConstraints { make in
            make.leading.equalTo(onePinButton.snp.trailing)
            make.top.equalTo(counterLabel.snp.bottom).offset(0.5*pinSpacing)
            make.height.equalTo(counterLabel.snp.height).offset(0.2*pinSpacing)
            make.width.equalTo(view.bounds.width/3)
        }
        
    }
    
    func checkRoll(){
        if currentIndex < 10 {
            if frame.firstRoll == [-1]{
                isFirstRoll = true
                self.frame.firstRoll = []
            }
            else if frame.secondRoll == [-1]{
                highlightFirstRoll()
                isFirstRoll = false
                self.frame.secondRoll = []
            }
            else {
                highlightSecondRoll()
//                print("In here")
            }
        }
        else{
            if frame.firstRoll == [-1]{
                isFirstRoll = true
                self.frame.firstRoll = []
            }
            else if frame.secondRoll == [-1]{
                if frame.firstRoll.count == 10{
                    isFirstRoll = false
                    self.frame.secondRoll = []
                }
                else {
                    highlightFirstRoll()
                    isFirstRoll = false
                    self.frame.secondRoll = []
                }
            }
            else if frame.thirdRoll == [-1]{
                if frame.secondRoll.count == 10 || frame.firstRoll.count + frame.secondRoll.count == 10 {
                    self.frame.thirdRoll = []
                    isFirstRoll = false
                    isThirdRoll = true
                }
                else if frame.firstRoll.count == 10 {
                    self.frame.thirdRoll = []
                    isFirstRoll = false
                    isThirdRoll = true
                    highlightSecondRollFrame10()
                }
                if frame.firstRoll.count + frame.secondRoll.count < 10{
//                    print("in here")
                    highlightSecondRoll()
                }
            }
            if frame.mutable == false{
                freezeFrame10()
            }
            
        }
    }
    
    func highlightFirstRoll(){
            for number in frame.firstRoll{
                convertDict[number]?.isEnabled = false
                convertDict[number]?.setImage(UIImage(systemName: "\(number).circle.fill", withConfiguration: imageConfig), for: .normal)
            }
    }
    
    func highlightSecondRoll(){
        
        for number in frame.firstRoll{
            convertDict[number]?.setImage(UIImage(systemName: "\(number).circle.fill", withConfiguration: imageConfig), for: .normal)
        }
        for number in frame.secondRoll{
            convertDict[number]?.setImage(UIImage(systemName: "\(number).circle.fill", withConfiguration: imageConfig), for: .normal)
        }
        for number in 1...10{
            convertDict[number]?.isEnabled = false
        }
    }
    
    func freezeFrame10(){
        if frame.firstRoll.count == 10{
            if frame.secondRoll.count < 10 {
                for number in frame.secondRoll{
                    convertDict[number]?.setImage(UIImage(systemName: "\(number).circle.fill", withConfiguration: imageConfig), for: .normal)
                }
                for number in frame.thirdRoll{
                    convertDict[number]?.setImage(UIImage(systemName: "\(number).circle.fill", withConfiguration: imageConfig), for: .normal)
                }
            }
            if frame.secondRoll.count == 10 {
                for number in frame.thirdRoll{
                    convertDict[number]?.setImage(UIImage(systemName: "\(number).circle.fill", withConfiguration: imageConfig), for: .normal)
                }
            }
        }
        else if frame.secondRoll.count == 10 || frame.firstRoll.count + frame.secondRoll.count == 10 {
            for number in frame.thirdRoll{
                convertDict[number]?.setImage(UIImage(systemName: "\(number).circle.fill", withConfiguration: imageConfig), for: .normal)
            }
        }
        else {
            for number in frame.firstRoll{
                convertDict[number]?.setImage(UIImage(systemName: "\(number).circle.fill", withConfiguration: imageConfig), for: .normal)
            }
            for number in frame.secondRoll{
                convertDict[number]?.setImage(UIImage(systemName: "\(number).circle.fill", withConfiguration: imageConfig), for: .normal)
            }
        }
        for number in 1...10{
                convertDict[number]?.isEnabled = false
        }
    }
    
    func highlightSecondRollFrame10(){
        
        for number in frame.secondRoll{
            convertDict[number]?.setImage(UIImage(systemName: "\(number).circle.fill", withConfiguration: imageConfig), for: .normal)
            convertDict[number]?.isEnabled = false
        }
    }
    
    @objc func clicked(button: UIButton) {
        let rConvertDict = [onePinButton: 1, twoPinButton: 2, threePinButton: 3, fourPinButton: 4, fivePinButton: 5,
                            sixPinButton: 6, sevenPinButton: 7, eightPinButton: 8, ninePinButton: 9, tenPinButton: 10]
        button.isSelected.toggle()
        if currentIndex < 10 {
            if button.isSelected {
                if isFirstRoll {
                    self.frame.firstRoll.append(rConvertDict[button]!)
                }
                else {
                    self.frame.secondRoll.append(rConvertDict[button]!)
                }
            }
            else {
                if isFirstRoll {
                    self.frame.firstRoll.remove(at: self.frame.firstRoll.firstIndex(of: rConvertDict[button]!)!)
                }
                else {
                    self.frame.secondRoll.remove(at: self.frame.secondRoll.firstIndex(of: rConvertDict[button]!)!)
                }
                
            }
        }
        if currentIndex == 10 {
            if button.isSelected {
//                print("in third frame")
                if isThirdRoll {
                    self.frame.thirdRoll.append(rConvertDict[button]!)
                }
                else if isFirstRoll {
                    self.frame.firstRoll.append(rConvertDict[button]!)
                }
                else {
                    self.frame.secondRoll.append(rConvertDict[button]!)
                }
            }
            else {
                if isThirdRoll {
                    self.frame.thirdRoll.remove(at: self.frame.thirdRoll.firstIndex(of: rConvertDict[button]!)!)
                }
                else if isFirstRoll {
                    self.frame.firstRoll.remove(at: self.frame.firstRoll.firstIndex(of: rConvertDict[button]!)!)
                }
                else {
                    self.frame.secondRoll.remove(at: self.frame.secondRoll.firstIndex(of: rConvertDict[button]!)!)
                }
            }
        }
        counter()
    }
    
    func counter() {
        var pinSum = 0
        var rollSum = 0
        for key in 1...10 {
            let button = convertDict[key]
            if button!.isSelected {
                rollSum += 1
            }
            else if button!.isEnabled == false {
                pinSum += 1
            }
        }
        if rollSum == 10 && specialButton.currentTitle == "Strike"{
            counterLabel.text = "Strike"
        }
        else if rollSum + pinSum == 10 {
            counterLabel.text = "Spare"
        }
        else if rollSum != 1 {
            counterLabel.text = "\(rollSum) Pins"
        }
        else {
            counterLabel.text = "1 Pin"
        }
    }
    
    @objc func specialFunction(button: UIButton) {
        if button.isEnabled {
            for key in 1...10 {
                let pinButton = convertDict[key]!
                if pinButton.isEnabled && !pinButton.isSelected {
                    clicked(button: pinButton)
                }
            }
        }
    }
    
    @objc func dismissVC() {
//        print("dismissing")
        self.delegate.updateFrame(frame: self.frame)
        dismiss(animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
