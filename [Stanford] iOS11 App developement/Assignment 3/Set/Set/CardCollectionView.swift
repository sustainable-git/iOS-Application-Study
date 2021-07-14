//
//  CardCollectionView.swift
//  ApplicationTest
//
//  Created by shin jae ung on 2021/07/14.
//

import UIKit

class CardCollectionView: UIView {

    var cardCollection = [CardView]() {
        willSet {
            cardCollection.forEach{$0.removeFromSuperview()}
        }
        didSet {
            cardCollection.forEach{addSubview($0)}
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var grid = Grid(layout: Grid.Layout.aspectRatio(31/44), frame: bounds)
        grid.cellCount = cardCollection.count
        
        cardCollection.indices.forEach {
            cardCollection[$0].frame = grid[$0]!.insetBy(dx: 2.0, dy: 2.0)
        }
    }
}
