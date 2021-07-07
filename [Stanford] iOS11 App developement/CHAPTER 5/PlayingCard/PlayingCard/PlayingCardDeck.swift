//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by shin jae ung on 2021/07/07.
//

import Foundation

struct PlayingCardDeck {
    private(set) var cards = [PlayingCard]()
    
    init() {
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else { return nil }
    }
}


extension Int {
    var arc4random: Int {
        if self > 0 { return Int(arc4random_uniform(UInt32(self))) }
        else { return -Int(arc4random_uniform(UInt32(-self))) }
    }
}
