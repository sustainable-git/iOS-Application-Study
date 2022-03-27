//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Shin Jae Ung on 2022/03/25.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private static let emojis = "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐽🐸🐵🐔🐧🐦".map { String($0) }
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
