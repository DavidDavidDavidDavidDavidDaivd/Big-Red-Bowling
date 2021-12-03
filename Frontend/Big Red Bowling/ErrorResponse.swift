//
//  ErrorResponse.swift
//  Big Red Bowling
//
//  Created by David Bertuch on 11/29/21.
//

import Foundation

struct ErrorResponse: Decodable {
    let success: Bool
    let error: String
}
