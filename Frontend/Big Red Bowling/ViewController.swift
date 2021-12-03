//
//  ViewController.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/13/21.
//

import UIKit
import SnapKit

//Global variables
let cornellRed = UIColor(hue: 0, saturation: 0.84, brightness: 0.7, alpha: 1.0)
let backgroundGray = UIColor(hue: 0.7861, saturation: 0, brightness: 0.97, alpha: 1.0)

class ViewController: UIViewController {
    //Home table view
    private let gameTableView = UITableView()
    private let gameReuseID = "gameReuseID"
    private let sidePadding = CGFloat(10)
    private let heightPadding = CGFloat(12)
    private let refreshGamesControl = UIRefreshControl()
    
    //Buttons
    private let addButton = UIBarButtonItem()
    private let settingsButton = UIBarButtonItem()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshGames()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initial alert
        if userName == "Player" {
            alertError(delegate: self, type: .changeName)
        }
        
        //Base Properties
        self.title = "Games"
        navigationController?.navigationBar.tintColor = cornellRed
        view.backgroundColor = backgroundGray
        localGameIDs = localGameIDs.sorted(by: >)
        
        //Table View Properties
        gameTableView.backgroundColor = .clear
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(GameCell.self, forCellReuseIdentifier: gameReuseID)
        gameTableView.sectionFooterHeight = heightPadding
        gameTableView.sectionHeaderHeight = heightPadding
        gameTableView.separatorColor = .clear
        gameTableView.tintColor = .clear
        //Refresh Control
        gameTableView.refreshControl = refreshGamesControl
        refreshGamesControl.addTarget(self, action: #selector(refreshGames), for: .valueChanged)
    
        
        //Add Button Properties
        addButton.image = UIImage(systemName: "plus")
        addButton.target = self
        addButton.action = #selector(selectNavButton)
        
        //Setting Button Properties
        settingsButton.image = UIImage(systemName: "gearshape")
        settingsButton.target = self
        settingsButton.action = #selector(selectNavButton)
        
        //add subviews
        view.addSubview(gameTableView)
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = settingsButton
        
        
        setupConstraints()
    }
    
    func setupConstraints() { //Setup Constraints
        gameTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(sidePadding)
            make.trailing.equalToSuperview().offset(-sidePadding)
        }
    }
    
    @objc func refreshGames() {
        //Function to refresh the games in the tableView// TODO: Make sure to reload JSONs
        updateDefaults()
        localGameIDs = localGameIDs.sorted(by: >)
        self.gameTableView.reloadData()
        refreshGamesControl.endRefreshing()
    }
    
    @objc func selectNavButton(button: UIBarButtonItem) {
        if button == addButton {
            let vc = AddGameViewController(delegate: self)
            present(vc, animated: true, completion: nil)
        }
        if button == settingsButton {
            let vc = SettingsViewController()
            present(vc, animated: true, completion: nil)
            
        }
    }
}
//MARK: TableView Delegation
extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //Set number of sections based on the amount of stored games
        return localGameIDs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //1 Cell per section
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //Configure padding between sections (cells)
        return heightPadding
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //Adds padding to the first cell
        if section == 0 {
                return 4
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //makes header clear, credit to Alex Reynolds on Stack Overflow
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //makes footer clear, credit to Alex Reynolds on Stack Overflow
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create GameCells
        if let gameCell = gameTableView.dequeueReusableCell(withIdentifier: gameReuseID, for: indexPath)
            as? GameCell {
            let gameIndex = localGameIDs[indexPath.section]
            NetworkManager.getGame(vc: self, gameID: gameIndex) { game in
                gameCell.setupGameCell(game: game)
            }
            //configues cell to have correct borders and shadows
            gameCell.layer.cornerRadius = 30
            gameCell.layer.shadowOpacity = 0.2
            gameCell.layer.shadowRadius = 1
            gameCell.layer.shadowOffset = CGSize(width: 0, height: 3)
            gameCell.selectionStyle = .none
//            print("Creating Game cell")
            return gameCell
        } else {
            return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDelegate {
    //Configure height. 3 Cells should be shown// scratch that, setting fixed height!
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = CGFloat(160)
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Push game viewcontroller when a game is tapped
        let gameID = localGameIDs[indexPath.section]
        NetworkManager.getGame(vc: self, gameID: gameID) { game in
            let vc = GameViewController(game: game)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Swipe action to delete
        let deleteButton = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            localGameIDs.remove(at: indexPath.section)
            
            self.refreshGames()
            completion(true)
        }
        deleteButton.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
}
