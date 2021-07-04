//
//  ViewController.swift
//  Concentration
//
//  Created by shin jae ung on 2021/06/28.
//

import UIKit

class ViewController: UIViewController {
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairOfCards)
    
    var numberOfPairOfCards : Int {
        return (cardButtons.count+1)/2
    }

    private(set) var flipCount = 0 {
        didSet { flipCountLabel.text = "Flip : \(flipCount)" }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    private var emojiChoices = ["👻", "🎃", "🍭", "🧁", "🏈", "🏹", "🏅"]
    
    private var emoji = [Int : String]()
    
    private func emoji(for card: Card) -> String {
        if emojiChoices.count > 0, emoji[card.identifier] == nil {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4ramdom)
        }
        
        return emoji[card.identifier] ?? "?"
    }

}

extension Int {
    var arc4ramdom : Int {
        if self > 0 { return Int(arc4random_uniform(UInt32(self))) }
        else { return -Int(arc4random_uniform(UInt32(self))) }
    }
}


