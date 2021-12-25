//
//  Card.swift
//  assignment1
//
//  Created by shin jae ung on 2021/06/30.
//

import Foundation

struct ConcentrationCard: Hashable {
    var isFaceUp = false
    var isMatched = false
    let identifier : Int
    
    static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        identifier = ConcentrationCard.getUniqueIdentifier()
    }
}

