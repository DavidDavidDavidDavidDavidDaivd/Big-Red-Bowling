//
//  AlertController.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/16/21.
//

import Foundation
import UIKit

enum Error {
    //Error Cases TODO: add all cases
    case invalidID
    case duplicatePlayerName
    case generalError
    case lostConnection
    case alreadyInGame
    case changeName
}

func alertError(delegate: UIViewController, type: Error) {
    //Posts an error to with given error to delegating view controller
    var alertController: UIAlertController?
    let message: String
    var title = "Uh-Oh!"
    switch type {
    case .invalidID:
        message = "That game ID does not exist"
    case .duplicatePlayerName:
        message = "That player already exists"
    case .generalError:
        message = "An error has occurred"
    case .lostConnection:
        message = "Failed to connect to server"
    case .alreadyInGame:
        message = """
                    The game has been added,
                    but that name is already in use
                    """
    case .changeName:
        message = "Click on settings to set your name!"
        title = "Welcome!"
    }
    alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController!.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
    alertController!.view.layoutIfNeeded()
    if !(delegate.navigationController?.visibleViewController is UIAlertController) {
        delegate.present(alertController!, animated: true)
    }
}
