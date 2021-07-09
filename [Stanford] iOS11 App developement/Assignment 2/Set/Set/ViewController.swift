//
//  ViewController.swift
//  Set
//
//  Created by shin jae ung on 2021/07/08.
//

import UIKit

class ViewController: UIViewController {
    private var set = SetGame()
    private var numberOfShowingCards = 12
    private lazy var cardIndexs = Array(0..<set.cards.count)
    private var buttonCardDict = [UIButton:Card]()
    private var isEnd = false
    
    override func viewDidLoad() {
        hintButton.layer.borderWidth = 2.0
        hintButton.layer.cornerRadius = 8.0
        hintButton.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        for index in 0..<numberOfShowingCards {
            buttonCardDict[buttonCollection[index]] = set.cards[cardIndexs.removeFirst()]
        }
        updateViewFromModel()
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var noticeLabel: UILabel!
    @IBOutlet private weak var hintButton: UIButton!
    @IBOutlet private var buttonCollection: [UIButton]!
    @IBOutlet private weak var deal3MoreButton: UIButton!
    @IBOutlet private weak var endLabel: UILabel!
    
    private func hint() -> (Int, Int, Int)? {
        for i in 0..<numberOfShowingCards-2 {
            for j in i+1..<numberOfShowingCards-1 {
                for k in j+1..<numberOfShowingCards {
                    guard let a = buttonCardDict[buttonCollection[i]] else { continue }
                    guard let b = buttonCardDict[buttonCollection[j]] else { continue }
                    guard let c = buttonCardDict[buttonCollection[k]] else { continue }
                    
                    if set.isSet([a,b,c]) {
                        return (i, j, k)
                    }
                }
            }
        }
        return nil
    }
    
    @IBAction private func touchHint(_ sender: Any) {
        if let (i, j, k) = hint() {
            buttonCollection[i].layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            buttonCollection[j].layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            buttonCollection[k].layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        else { return }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        guard !isEnd else { return }
        guard let card = buttonCardDict[sender] else { return }
        set.selectCard(card)
        updateViewFromModel()
        for (key, value) in buttonCardDict {
            if set.matchedCardArr.contains(value) { // matched
                if cardIndexs.count > 0 { buttonCardDict.updateValue(set.cards[cardIndexs.removeFirst()], forKey: key) }
                else { buttonCardDict[key] = nil }
            }
        }
        
        if hint() == nil && cardIndexs.count == 0 { // end condition
            isEnd = true
            updateViewFromModel()
        }
    }
    
    @IBAction private func newGameButton(_ sender: UIButton) {
        set.reset()
        numberOfShowingCards = 12
        cardIndexs = Array(0..<set.cards.count)
        buttonCardDict.removeAll()
        isEnd = false
        for index in 0..<numberOfShowingCards {
            buttonCardDict[buttonCollection[index]] = set.cards[cardIndexs.removeFirst()]
        }
        updateViewFromModel()
    }
    
    @IBAction private func touchDeal3MoreButton(_ sender: Any) {
        if set.isMatched {
            set.selectedCardArr.removeAll()
        } else if numberOfShowingCards < 24 && cardIndexs.count > 0 {
            for _ in 0..<3 {
                buttonCardDict[buttonCollection[numberOfShowingCards]] = set.cards[cardIndexs.removeFirst()]
                numberOfShowingCards += 1
            }
        }
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        if isEnd { // end condition
            endLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            endLabel.numberOfLines = 2
            endLabel.backgroundColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
            endLabel.text = "Clear \n Score: \(set.score)"
            return
        }
        else {
            endLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            endLabel.text = ""
        }
        
        scoreLabel.text = "Score: \(set.score)" // scoring labeling
        
        if set.selectedCardArr.count == 3 { // notice labeling
            if set.isSet(set.selectedCardArr){ noticeLabel.text = "Matched" }
            else { noticeLabel.text = "misMatched" }
        } else { noticeLabel.text = "" }
        
        if set.isMatched || (numberOfShowingCards < 24 && cardIndexs.count != 0) { // deal 3 more button showing
            deal3MoreButton.setTitle("Deal 3 more", for: UIControl.State.normal)
            deal3MoreButton.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        } else {
            deal3MoreButton.setTitle("", for: UIControl.State.normal)
            deal3MoreButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
        
        for index in buttonCollection.indices { // card showing
            let button = buttonCollection[index]
            if let card = buttonCardDict[button] {
                if index < numberOfShowingCards {
                    if set.selectedCardArr.contains(card) { button.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)}
                    else { button.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
                    button.layer.borderWidth = 3.0
                    button.layer.cornerRadius = 8.0
                    let attributedTitle = cardShape(ofCard: card)
                    button.setAttributedTitle(attributedTitle, for: UIControl.State.normal)
                } else {
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                }
            } else {
                button.setAttributedTitle(NSAttributedString(string: ""), for: UIControl.State.normal)
                button.layer.borderWidth = 0.0
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            }
        }
    }

    private func cardShape(ofCard card: Card) -> NSAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [:]
        var string = ""
        
        switch card.color {
        case .red :     attributes.updateValue(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), forKey: .strokeColor)
        case .green :   attributes.updateValue(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), forKey: .strokeColor)
        case .blue :    attributes.updateValue(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), forKey: .strokeColor)
        }
        
        switch card.shape {
        case .triangle : string = "▲"
        case .square : string = "■"
        case .circle : string = "●"
        }
        
        switch card.shade {
        case .none : attributes.updateValue(5, forKey: .strokeWidth)
        case .half : attributes.updateValue(-1, forKey: .strokeWidth)
            switch card.color {
            case .red : attributes.updateValue(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.1489807533), forKey: .foregroundColor)
            case .green : attributes.updateValue(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 0.1479977235), forKey: .foregroundColor)
            case .blue : attributes.updateValue(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 0.15), forKey: .foregroundColor)
            }
        case .full : attributes.updateValue(-1, forKey: .strokeWidth)
            switch card.color {
            case .red : attributes.updateValue(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), forKey: .foregroundColor)
            case .green : attributes.updateValue(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), forKey: .foregroundColor)
            case .blue : attributes.updateValue(#colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), forKey: .foregroundColor)
            }
        }
        
        switch card.number {
        case .one : break
        case .two : string += String(string.first!)
        case .three : string += String(string.first!) + String(string.first!)
        }
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return attributedString
    }
}

extension SetGame {
    var isMatched : Bool {
        if selectedCardArr.count == 3 && isSet(selectedCardArr) { return true }
        else { return false }
    }
}
