//
//  SetGame.swift
//  SetGame
//
//  Created by Shin Jae Ung on 2022/04/24.
//

import Foundation

struct SetGame {
    private(set) var selectedCards: [Card] = []
    private(set) var showingCards: [Card] = []
    private(set) var score: Int = 0
    private var cardDeck: [Card] = []
    private var numberOfInitialCards: Int
    var isDeckEmpty: Bool {
        return self.cardDeck.isEmpty
    }
    var isMatched: Bool {
        return self.isMatchedSetOf(cards: self.selectedCards)
    }
    var hint: [Card] {
        for i in (0..<self.showingCards.count - 2) {
            for j in (i + 1..<self.showingCards.count - 1) {
                for k in (j + 1..<self.showingCards.count) {
                    let cards = [self.showingCards[i], self.showingCards[j], self.showingCards[k]]
                    if self.isMatchedSetOf(cards: cards) {
                        return cards
                    }
                }
            }
        }
        return []
    }
    var isGameOver: Bool {
        return self.isDeckEmpty && self.hint.count == 0
    }
    
    init(numberOfInitialCards: Int) {
        self.numberOfInitialCards = numberOfInitialCards
        self.reset()
    }
    
    private func isMatchedSetOf(cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }
        if cards.set({ $0.shade }).count == 2 ||
            cards.set({ $0.color }).count == 2 ||
            cards.set({ $0.format }).count == 2 ||
            cards.set({ $0.number }).count == 2 {
            return false
        }
        return true
    }
    
    mutating func clearIfMatched() {
        guard self.isMatched else { return }
        while !self.selectedCards.isEmpty {
            let matchedCard = self.selectedCards.removeFirst()
            guard let replaceIndex = self.showingCards.firstIndex(where: { $0 == matchedCard }) else { return }
            if !self.isDeckEmpty {
                self.showingCards[replaceIndex] = self.cardDeck.removeFirst()
            } else {
                self.showingCards.remove(at: replaceIndex)
            }
        }
        self.selectedCards.removeAll()
    }
    
    mutating func reset() {
        var idFactory: Int = 0
        self.score = 0
        self.cardDeck.removeAll()
        self.selectedCards.removeAll()
        self.showingCards.removeAll()
        for color in CardShapeColor.allCases {
            for number in CardShapeNumber.allCases {
                for format in CardShapeFormat.allCases {
                    for shade in CardShapeShade.allCases {
                        self.cardDeck.append(Card(color: color, number: number, format: format, shade: shade, id: idFactory))
                        idFactory += 1
                    }
                }
            }
        }
        self.cardDeck.shuffle()
        (0..<self.numberOfInitialCards).forEach { _ in
            self.drawCard()
        }
    }
    
    mutating func select(card: Card) {
        if self.isMatched {
            while !self.selectedCards.isEmpty {
                let matchedCard = self.selectedCards.removeFirst()
                guard let replaceIndex = self.showingCards.firstIndex(where: { $0 == matchedCard }) else { return }
                if !self.isDeckEmpty {
                    self.showingCards[replaceIndex] = self.cardDeck.removeFirst()
                } else {
                    self.showingCards.remove(at: replaceIndex)
                }
            }
        }
        
        if self.selectedCards.count == 3 { self.selectedCards.removeAll() }
        if !showingCards.contains(card) { return }
        
        if self.selectedCards.contains(card) {
            guard let selectedCardIndex = self.selectedCards.firstIndex(where: { $0 == card }) else { return }
            self.selectedCards.remove(at: selectedCardIndex)
            self.score -= 1
        } else {
            self.selectedCards.append(card)
        }
        
        if self.selectedCards.count == 3 {
            if self.isMatched {
                self.score += 3
            } else {
                self.score -= 3
            }
        }
    }
    
    
    mutating func drawCard() {
        guard !self.isDeckEmpty else { return }
        self.showingCards.append(self.cardDeck.removeFirst())
    }
    
    struct Card: Equatable, Identifiable {
        let color: CardShapeColor
        let number: CardShapeNumber
        let format: CardShapeFormat
        let shade: CardShapeShade
        var id: Int
    }
}

private extension Collection {
    func set<T: Hashable>(_ transform: (Element) -> T) -> Set<T> {
        var mySet = Set<T>()
        for element in self {
            mySet.update(with: transform(element))
        }
        return mySet
    }
}
