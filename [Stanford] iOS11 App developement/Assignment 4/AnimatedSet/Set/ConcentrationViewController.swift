//
//  ViewController.swift
//  assignment1
//
//  Created by shin jae ung on 2021/06/30.
//

import UIKit

class ConcentrationViewController: UIViewController {
    lazy var game = ConcentrationGame(numberOfPairsOfCards: buttonCollection.count/2)
    
    @IBOutlet var buttonCollection: [UIButton]!
    @IBAction func buttonTouch(_ sender: UIButton) {
        if let index = buttonCollection.firstIndex(of: sender) {
            game.cardTouch(at: index)
            updateViewFromModel()
        } else {
            print("the button is not linked with buttonCollection")
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBAction func newGameButton(_ sender: UIButton) {
        game.restart()
        updateViewFromModel()
        theme = emojiChoices
        self.emoji.removeAll()
    }
    
    func updateViewFromModel() { // buttonTouched -> seek all cards and change View
        for index in game.cards.indices {
            let button = buttonCollection[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(icon(ofCard: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        flipCountLabel.text = "Flip : \(game.flipCount)"
        scoreLabel.text = "Score : \(game.score)"
    }
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji.removeAll()
            self.updateViewFromModel()
        }
    }
    
    private var emojiChoices = "🦇😱🙀👿🎃👻🍭🍬🍎"
    private var emoji = [ConcentrationCard: String]()
    private func icon(ofCard card: ConcentrationCard) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
