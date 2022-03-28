//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Shin Jae Ung on 2022/03/25.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    enum EmojiCollection: String, CaseIterable {
        case animals = "Animals", vehicles = "Vehicles", fruits = "Fruits",
             activities = "Activities", foods = "Foods", faces = "Faces"
        
        static var random: EmojiCollection {
            return EmojiCollection.allCases.randomElement()!
        }
        
        var emojis: [String] {
            switch self {
            case .animals: return "🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨".map{ String($0) }
            case .vehicles: return  "🚗🛳🏍🚌🚁🏎🚑🚒✈️🚆".map{ String($0) }
            case .fruits: return "🍎🍉🍇🍓🍒🥝🍆🥑🍍🫐".map{ String($0) }
            case .activities: return "⚽️🏈🏀🎾⛷🥊🥋🪂🛹⛳️".map{ String($0) }
            case .foods: return "🥟🍤🍡🍭🍪🍫🍔🌭🍖🥨".map{ String($0) }
            case .faces: return "😡🤯🥶😱🤢😈👹🤡🎃👽".map{ String($0) }
            }
        }
        
        var color: Color {
            switch self {
            case .animals: return .red
            case .vehicles: return .blue
            case .fruits: return .green
            case .activities: return .mint
            case .foods: return .yellow
            case .faces: return .pink
            }
        }
    }
    
    @Published private var model: MemoryGame<String>!
    private(set) var title: String = ""
    private(set) var color: Color = .clear
    var cards: Array<MemoryGame<String>.Card> { return model.cards }
    var score: Int { return model.score }
    
    
    init() {
        self.model = self.createMemoryGame()
    }
    
    func choose(_ card: MemoryGame<String>.Card) {
        self.model.choose(card)
    }
    
    func newGame() {
        self.model = self.createMemoryGame()
    }
    
    private func createMemoryGame() -> MemoryGame<String> {
        let emojiCollection = EmojiCollection.random
        var emojis = emojiCollection.emojis.shuffled()
        self.title = emojiCollection.rawValue
        self.color = emojiCollection.color
        let numberOfPairs = emojis.count >= 6 ? 6 : emojis.count
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { _ in
            return emojis.removeFirst()
        }
    }
}
