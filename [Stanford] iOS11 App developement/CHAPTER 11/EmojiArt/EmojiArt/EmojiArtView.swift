//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by shin jae ung on 2022/02/04.
//

import UIKit

class EmojiArtView: UIView {
    var backgroundImage: UIImage? { didSet { setNeedsDisplay() } }
    
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
}
