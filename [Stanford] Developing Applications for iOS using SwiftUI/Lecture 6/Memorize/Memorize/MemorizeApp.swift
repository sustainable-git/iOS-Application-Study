//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Shin Jae Ung on 2022/03/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
