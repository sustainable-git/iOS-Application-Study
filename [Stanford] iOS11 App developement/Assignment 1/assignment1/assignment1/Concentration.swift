//
//  Concentration.swift
//  assignment1
//
//  Created by shin jae ung on 2021/06/30.
//

import Foundation

class Concentration {
    var flipCount = 0
    var score = 0
    var flipedCardIndex : Int?
    var cards = [Card]()
    lazy var checkedCardIndexArray = Array(repeating: false, count: cards.count)
    
    init(numberOfPairsOfCards : Int) {
        for _ in 0..<numberOfPairsOfCards {
            let newCard = Card()
            cards += [newCard, newCard]
        }
        cards.shuffle()
    }
    
    func restart() {
        flipCount = 0
        score = 0
        flipedCardIndex = nil
        checkedCardIndexArray = Array(repeating: false, count: cards.count)
        for cardResetIndex in cards.indices {
            cards[cardResetIndex].isFaceUp = false
            cards[cardResetIndex].isMatched = false
        }
        cards.shuffle()
    }
    
    func cardTouch(at index : Int) {
        guard !cards[index].isMatched else { return }
        if !cards[index].isFaceUp { flipCount += 1 }
        
        if let matchIndex = flipedCardIndex, matchIndex != index {
            if cards[index].identifier == cards[matchIndex].identifier { // matched
                cards[index].isMatched = true
                cards[matchIndex].isMatched = true
                score += 2
            } else { // miss matched
                if checkedCardIndexArray[matchIndex] { score -= 1 }
                if checkedCardIndexArray[index] { score -= 1 }
                checkedCardIndexArray[matchIndex] = true
                checkedCardIndexArray[index] = true
            }
            cards[index].isFaceUp = true
            flipedCardIndex = nil
        } else {
            for flipDownIndex in cards.indices {
                cards[flipDownIndex].isFaceUp = false
            }
            cards[index].isFaceUp = true
            flipedCardIndex = index
        }
    }
    
}
