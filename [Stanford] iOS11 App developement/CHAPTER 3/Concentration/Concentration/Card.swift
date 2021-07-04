//
//  card.swift
//  Concentration
//
//  Created by shin jae ung on 2021/06/29.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var identifier : Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
