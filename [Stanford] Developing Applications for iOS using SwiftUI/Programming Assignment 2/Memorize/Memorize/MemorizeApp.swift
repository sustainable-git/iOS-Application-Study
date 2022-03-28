//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Shin Jae Ung on 2022/03/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
