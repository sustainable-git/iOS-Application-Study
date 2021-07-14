//
//  SetGame.swift
//  Set
//
//  Created by shin jae ung on 2021/07/08.
//

import Foundation

private func initializer() -> [Card] {
    var returnArr = [Card]()
    
    for shape in Shape.all {
        for number in Number.all {
            for shade in Shade.all {
                for color in Color.all {
                    let card = Card.init(color: color, shade: shade, number: number, shape: shape)
                    returnArr.append(card)
                }
            }
        }
    }
    
    return returnArr
}

struct SetGame {
    var cards = initializer().shuffled()
    var matchedCardArr = [Card]()
    var selectedCardArr = [Card]()
    var score = 0
    
    mutating func selectCard(_ card : Card) {
        guard !matchedCardArr.contains(card) else { return } // you can't select matched card
        if selectedCardArr.count >= 3 { selectedCardArr.removeAll() }
        
        if selectedCardArr.count < 3 {
            if selectedCardArr.contains(card){ // deselection
                let position = selectedCardArr.firstIndex(of: card)!
                selectedCardArr.remove(at: position)
                score -= 1
            } else { selectedCardArr.append(card) }
        }
        
        guard selectedCardArr.count == 3 else { return } // if you picked 3, do below
        if isSet(selectedCardArr) { // matched
            matchedCardArr += selectedCardArr
            score += 3
        } else { // not matched
            score -= 5
        }
    }
    
    mutating func reset() {
        cards = initializer().shuffled()
        matchedCardArr.removeAll()
        selectedCardArr.removeAll()
        score = 0
    }
    
    func isSet(_ threeCards: [Card]) -> Bool {
        guard threeCards.count == 3 else { return false }
        if Set(threeCards.map{$0.color}).count == 2 { return false }
        if Set(threeCards.map{$0.shade}).count == 2 { return false }
        if Set(threeCards.map{$0.number}).count == 2 { return false }
        if Set(threeCards.map{$0.shape}).count == 2 { return false }
        return true
    }
}
