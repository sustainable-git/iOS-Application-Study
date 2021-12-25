//
//  CardCollectionView.swift
//  ApplicationTest
//
//  Created by shin jae ung on 2021/07/14.
//

import UIKit

class CardCollectionView: UIView {
    var cardCollection = [CardView]()
    weak var endView: UIView?
    weak var startView: UIView?
    private var isAnimating: Bool = false
    private var shouldAnimate: Bool {
        guard let firstFrame = gridFrame(at: 0) else { return false }
        return self.cardCollection[0].frame == firstFrame ? false : true
    }
    private lazy var grid = Grid(layout: Grid.Layout.aspectRatio(31/44), frame: self.bounds)
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self)
    private lazy var cardBehavior: CardBehaivor = CardBehaivor(in: self.animator)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.grid.frame = self.bounds
        if !isAnimating {
            self.cardCollection.indices.forEach { [unowned self] in
                self.configureCardCollection(at: $0, grid: self.grid)
            }
        }
    }
    
    func append(cards: [CardView]) {
        self.cardCollection.append(contentsOf: cards)
        self.grid.cellCount = cardCollection.count
        if shouldAnimate {
            self.allCardsShouldAnimate { [weak self] in
                self?.appendCardsWithAnimation(to: cards)
            }
        } else {
            self.allCardsShouldLayout { [weak self] in
                self?.appendCardsWithAnimation(to: cards)
            }
        }
    }
    
    func remove(at: Int) {
        self.isAnimating = true
        let cardView = self.cardCollection.remove(at: at)
        self.grid.cellCount = cardCollection.count
        self.bringSubviewToFront(cardView)
        self.cardBehavior.add(item: cardView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self,
                  let endView = self.endView,
                  let superview = self.superview else { return }
            self.cardBehavior.remove(item: cardView)
            let snapOrigin = superview.convert(self.center, to: self)
            let snapBehavior = UISnapBehavior(item: cardView, snapTo: snapOrigin)
            snapBehavior.damping = 0.1
            self.animator.addBehavior(snapBehavior)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.animator.removeBehavior(snapBehavior)
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 1,
                    delay: 0,
                    options: .curveEaseInOut) {
                        self.cardTransform(from: cardView, to: endView)
                    } completion: { _ in
                        UIView.transition(
                            with: cardView,
                            duration: 1,
                            options: .transitionFlipFromLeft) {
                                cardView.isFaceUp = false
                            } completion: { _ in
                                self.sendSubviewToBack(cardView)
                            }
                    }
            }
        }
        if self.shouldAnimate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [weak self] in
                self?.allCardsShouldAnimate()
                self?.isAnimating = false
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [weak self] in
                self?.isAnimating = false
            }
        }
    }
    
    private func cardTransform(from cardView: UIView, to targetView: UIView) {
        let convertedOrigin = targetView.convert(CGPoint(x: 0, y: 0), to: self)
        let ratio: CGFloat = targetView.frame.height / cardView.frame.width
        let diffX: CGFloat = (cardView.frame.width - ratio * cardView.frame.width) / 2
        let diffY: CGFloat = (cardView.frame.height - ratio * cardView.frame.height) / 2
        let difference: CGFloat = (cardView.frame.height - cardView.frame.width) / 2
        let resizer = CGAffineTransform(scaleX: ratio, y: ratio)
        let mover = CGAffineTransform(translationX: convertedOrigin.x - cardView.frame.minX + difference - diffY, y: convertedOrigin.y - cardView.frame.minY - difference - diffX)
        let rotator = CGAffineTransform(rotationAngle: .pi/2)
        let combination = resizer.concatenating(rotator).concatenating(mover)
        cardView.transform = combination
    }
    
    private func appendCardsWithAnimation(to views: [CardView]) {
        guard let cardView = views.first,
              let startView = self.startView
        else { return }
        self.cardTransform(from: cardView, to: startView)
        self.addSubview(cardView)
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut) {
                cardView.transform = CGAffineTransform.identity
            } completion: { [weak self] _ in
                UIView.transition(
                    with: cardView,
                    duration: 0.5,
                    options: .transitionFlipFromRight) {
                        cardView.isFaceUp = true
                    }
                self?.appendCardsWithAnimation(to: Array(views.dropFirst()))
            }
    }
    
    private func allCardsShouldLayout(completion: @escaping() -> () = {}) {
        self.cardCollection.indices.forEach { [weak self] index in
            guard let self = self else { return }
            self.configureCardCollection(at: index, grid: self.grid)
        }
        completion()
    }
    
    private func allCardsShouldAnimate(completion: @escaping () -> () = {}) {
        self.cardCollection.indices.forEach { index in
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: 1,
                delay: 0,
                options: .curveEaseInOut) { [weak self] in
                    guard let self = self else { return }
                    self.configureCardCollection(at: index, grid: self.grid)
                    self.cardCollection[index].setNeedsDisplay() // border: draw again
                }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion()
        }
    }
    
    private func configureCardCollection(at index: Int, grid: Grid) {
        guard let frame = self.gridFrame(at: index) else { return }
        self.cardCollection[index].frame = frame
    }
    
    private func gridFrame(at index: Int) -> CGRect? {
        return grid[index]?.insetBy(dx: 2.0, dy: 2.0)
    }
}
