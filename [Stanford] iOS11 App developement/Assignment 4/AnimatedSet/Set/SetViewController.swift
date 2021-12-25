//
//  ViewController.swift
//  Set
//
//  Created by shin jae ung on 2021/07/08.
//

import UIKit

class SetViewController: UIViewController {
    private var set = SetGame()
    private var numberOfShowingCards = 12
    private lazy var cardIndexs = Array(0..<set.cards.count)
    private var viewCardDict = [UIView:SetCard]()
    private var isEnd = false
    
    @IBOutlet private weak var setLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var noticeLabel: UILabel!
    @IBOutlet private weak var hintButton: UIButton!
    @IBOutlet private weak var newGameButton: UIButton!
    @IBOutlet private weak var deal3MoreButton: UIButton!
    @IBOutlet private weak var endLabel: UILabel!
    @IBOutlet private weak var cardCollectionView: CardCollectionView!
    
    override func viewDidLoad() {
        self.configureLayout()
        self.configureCardCollectionView()
        self.initializeCardCollectionView()
        self.updateViewFromModel()
    }
    
    private func configureLayout() {
        self.newGameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.setLabel.adjustsFontSizeToFitWidth = true
        self.deal3MoreButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    private func configureCardCollectionView() {
        self.cardCollectionView.startView = self.deal3MoreButton
        self.cardCollectionView.endView = self.setLabel
        self.cardCollectionView.layoutSubviews()
    }
    
    private func initializeCardCollectionView() {
        var cardViews: [CardView] = []
        for _ in 0..<self.numberOfShowingCards {
            let card = self.set.cards[cardIndexs.first!]
            let cardView = self.newCardView(shape: card.shape, number: card.number, shade: card.shade, color: card.color)
            cardViews.append(cardView)
            self.viewCardDict[cardView] = set.cards[cardIndexs.removeFirst()]
        }
        self.cardCollectionView.append(cards: cardViews)
    }
    
    private func hint() -> (SetCard, SetCard, SetCard)? {
        numberOfShowingCards = cardCollectionView.cardCollection.count // initialize
        
        for i in 0..<numberOfShowingCards-2 {
            for j in i+1..<numberOfShowingCards-1 {
                for k in j+1..<numberOfShowingCards {
                    guard let a = viewCardDict[cardCollectionView.cardCollection[i]] else { continue }
                    guard let b = viewCardDict[cardCollectionView.cardCollection[j]] else { continue }
                    guard let c = viewCardDict[cardCollectionView.cardCollection[k]] else { continue }

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
            for cardView in cardCollectionView.cardCollection {
                if viewCardDict[cardView] == i || viewCardDict[cardView] == j || viewCardDict[cardView] == k {
                    cardView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                }
            }
        }
        else { return }
    }
    
    @objc private func tapCard(_ sender: UITapGestureRecognizer) {
        guard !isEnd else { return }
        guard let tappedCard = sender.view as? CardView else { return }
        guard let card = viewCardDict[tappedCard] else { return }
        self.set.selectCard(card)
        var newCardViews: [CardView] = []
        for (key, value) in viewCardDict {
            
            if set.matchedCardArr.contains(value) { // matched
                if cardIndexs.count > 0 {
                    let newCard = set.cards[cardIndexs.removeFirst()]
                    let newCardView = self.newCardView(shape: newCard.shape, number: newCard.number, shade: newCard.shade, color: newCard.color)
                    newCardViews.append(newCardView)
                    viewCardDict.updateValue(newCard, forKey: newCardView)
                }
                viewCardDict[key] = nil
            }
        }
        if newCardViews.count != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.cardCollectionView.append(cards: newCardViews)
            }
        }
        self.updateViewFromModel()
        if hint() == nil && cardIndexs.count == 0 { // end condition
            isEnd = true
            updateViewFromModel()
        }
    }
    
    
    
    @IBAction private func newGameButton(_ sender: UIButton) {
        self.set.reset()
        self.numberOfShowingCards = 12
        self.cardIndexs = Array(0..<set.cards.count)
        self.viewCardDict.removeAll()
        self.isEnd = false
        self.cardCollectionView.cardCollection.removeAll()
        self.cardCollectionView.subviews.forEach { $0.removeFromSuperview() }
        self.initializeCardCollectionView()
        self.updateViewFromModel()
    }
    
    @IBAction private func touchDeal3MoreButton(_ sender: Any) {
        if cardIndexs.count > 0 {
            var cardViews: [CardView] = []
            for _ in 0..<3 {
                let card = set.cards[cardIndexs.first!]
                let cardView = CardView()
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
                cardView.addGestureRecognizer(tap)
                cardView.initialize(shape: card.shape, number: card.number, shade: card.shade, color: card.color)
                cardViews.append(cardView)
                
                viewCardDict[cardView] = set.cards[cardIndexs.removeFirst()]
                numberOfShowingCards += 1
            }
            cardCollectionView.append(cards: cardViews)
        }
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        if isEnd { // end condition
            endLabel.backgroundColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
            endLabel.text = "Clear \n Score: \(set.score)"
            return
        } else {
            endLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            endLabel.text = ""
        }
        if self.set.matchedCardArr.count == 0 {
            self.setLabel.text = "Set"
        } else {
            self.setLabel.text = "Set : \(self.set.matchedCardArr.count/3)"
        }
        
        self.scoreLabel.text = "Score: \(set.score)" // scoring labeling
        
        
        if set.selectedCardArr.count == 3 { // notice labeling
            if set.isSet(set.selectedCardArr){ noticeLabel.text = "Matched" }
            else { noticeLabel.text = "misMatched" }
        } else { noticeLabel.text = "" }
        
        if cardIndexs.count != 0 { // deal 3 more button showing
            deal3MoreButton.setTitle("Deal", for: UIControl.State.normal)
            deal3MoreButton.backgroundColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        } else {
            deal3MoreButton.setTitle("", for: UIControl.State.normal)
            deal3MoreButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }
    
        for cardView in cardCollectionView.cardCollection { // card showing
            if let card = viewCardDict[cardView] {
                if set.selectedCardArr.contains(card) { cardView.layer.borderColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)}
                else { cardView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
            } else {
                let index = self.cardCollectionView.cardCollection.firstIndex(of: cardView)!
                self.cardCollectionView.cardCollection[index].layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                self.cardCollectionView.remove(at: index) // deleting : AutoLayout
            }
        }
    }
    
    private func newCardView(shape: SetCard.Shape, number: SetCard.Number, shade: SetCard.Shade, color: SetCard.Color) -> CardView {
        let cardView = CardView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
        cardView.initialize(shape: shape, number: number, shade: shade, color: color)
        cardView.addGestureRecognizer(tap)
        return cardView
    }
}

extension SetGame {
    var isMatched : Bool {
        if selectedCardArr.count == 3 && isSet(selectedCardArr) { return true }
        else { return false }
    }
}
