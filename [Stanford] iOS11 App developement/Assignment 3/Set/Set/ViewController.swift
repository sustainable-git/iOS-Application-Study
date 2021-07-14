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
    private var buttonCardDict = [UIView:Card]()
    private var isEnd = false
    
    override func viewDidLoad() {
        hintButton.layer.borderWidth = 2.0
        hintButton.layer.cornerRadius = 8.0
        hintButton.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        for _ in 0..<numberOfShowingCards {
            let card = set.cards[cardIndexs.first!]
            let cardView = CardView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
            cardView.addGestureRecognizer(tap)
            cardView.initialize(shape: card.shape, number: card.number, shade: card.shade, color: card.color)
            buttonCollection.cardCollection.append(cardView)
            
            buttonCardDict[cardView] = set.cards[cardIndexs.removeFirst()]
        }
        updateViewFromModel()
    }
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var noticeLabel: UILabel!
    @IBOutlet private weak var hintButton: UIButton!
    @IBOutlet private weak var deal3MoreButton: UIButton!
    @IBOutlet private weak var endLabel: UILabel!
    @IBOutlet private weak var buttonCollection: CardCollectionView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(touchDeal3MoreButton(_:)))
            swipe.direction = [.down]
            buttonCollection.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(reShuffle(_:)))
            buttonCollection.addGestureRecognizer(rotate)
        }
    }
    
    @objc private func reShuffle(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended : buttonCollection.cardCollection.shuffle()
        default : break
        }
    }
    
    private func hint() -> (Card, Card, Card)? {
        for i in 0..<numberOfShowingCards-2 {
            for j in i+1..<numberOfShowingCards-1 {
                for k in j+1..<numberOfShowingCards {
                    guard let a = buttonCardDict[buttonCollection.cardCollection[i]] else { continue }
                    guard let b = buttonCardDict[buttonCollection.cardCollection[j]] else { continue }
                    guard let c = buttonCardDict[buttonCollection.cardCollection[k]] else { continue }

                    if set.isSet([a,b,c]) {
                        return (a, b, c)
                    }
                }
            }
        }
        return nil
    }
    
    @IBAction private func touchHint(_ sender: Any) {
        if let (i, j, k) = hint() {
            for cardView in buttonCollection.cardCollection {
                if buttonCardDict[cardView] == i || buttonCardDict[cardView] == j || buttonCardDict[cardView] == k {
                    cardView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            }
        }
        else { return }
    }
    
    @objc private func tapCard(_ sender: UITapGestureRecognizer) {
        guard !isEnd else { return }
        guard let tappedCard = sender.view as? CardView else { return }
        guard let card = buttonCardDict[tappedCard] else { return }
        set.selectCard(card)
        updateViewFromModel()
        for (key, value) in buttonCardDict {
            if set.matchedCardArr.contains(value) { // matched
                if cardIndexs.count > 0 {
                    let newCard = set.cards[cardIndexs.removeFirst()]
                    buttonCardDict.updateValue(newCard, forKey: key)
                }
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
        buttonCollection.cardCollection.removeAll()
        for _ in 0..<numberOfShowingCards {
            let card = set.cards[cardIndexs.first!]
            let cardView = CardView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
            cardView.addGestureRecognizer(tap)
            cardView.initialize(shape: card.shape, number: card.number, shade: card.shade, color: card.color)
            buttonCollection.cardCollection.append(cardView)
            
            buttonCardDict[cardView] = set.cards[cardIndexs.removeFirst()]
        }
        updateViewFromModel()
    }
    
    @IBAction private func touchDeal3MoreButton(_ sender: Any) {
        if set.isMatched {
            set.selectedCardArr.removeAll()
        } else if cardIndexs.count > 0 {
            for _ in 0..<3 {
                let card = set.cards[cardIndexs.first!]
                let cardView = CardView()
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
                cardView.addGestureRecognizer(tap)
                cardView.initialize(shape: card.shape, number: card.number, shade: card.shade, color: card.color)
                buttonCollection.cardCollection.append(cardView)
                
                buttonCardDict[cardView] = set.cards[cardIndexs.removeFirst()]
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
        } else {
            endLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            endLabel.text = ""
        }
        
        scoreLabel.text = "Score: \(set.score)" // scoring labeling
        
        if set.selectedCardArr.count == 3 { // notice labeling
            if set.isSet(set.selectedCardArr){ noticeLabel.text = "Matched" }
            else { noticeLabel.text = "misMatched" }
        } else { noticeLabel.text = "" }
        
        if set.isMatched || cardIndexs.count != 0 { // deal 3 more button showing
            deal3MoreButton.setTitle("Deal 3 more", for: UIControl.State.normal)
            deal3MoreButton.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        } else {
            deal3MoreButton.setTitle("", for: UIControl.State.normal)
            deal3MoreButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
    
        for cardView in buttonCollection.cardCollection { // card showing
            if let card = buttonCardDict[cardView] {
                cardView.initialize(shape: card.shape, number: card.number, shade: card.shade, color: card.color)
                cardView.setNeedsDisplay()
                
                if set.selectedCardArr.contains(card) { cardView.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)}
                else { cardView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
                cardView.layer.borderWidth = 3.0
                cardView.layer.cornerRadius = 8.0
            } else {
                cardView.removeFromSuperview()
                
                let index = buttonCollection.cardCollection.firstIndex(of: cardView)
                buttonCollection.cardCollection.remove(at: index!) // deleting : AutoLayout
            }
        }
    }
}

extension SetGame {
    var isMatched : Bool {
        if selectedCardArr.count == 3 && isSet(selectedCardArr) { return true }
        else { return false }
    }
}
