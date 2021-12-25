//
//  CardView.swift
//  Set
//
//  Created by shin jae ung on 2021/07/12.
//

import UIKit

class CardView: UIView { // 31 x 44 크기
    var shape : SetCard.Shape?
    var number : SetCard.Number?
    var shade : SetCard.Shade?
    var color : SetCard.Color?
    var isFaceUp: Bool = false {
        didSet { setNeedsDisplay(); setNeedsLayout() }
    }
    
    func initialize(shape: SetCard.Shape, number: SetCard.Number, shade: SetCard.Shade, color: SetCard.Color) {
        self.shape = shape
        self.number = number
        self.shade = shade
        self.color = color
        self.clipsToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        guard shape != nil && number != nil && shade != nil && color != nil else { return }
        self.layer.cornerRadius = self.cardCornerRadius
        self.layer.borderWidth = self.strokeWidth
        if !isFaceUp {
            if let cardBackImage = UIImage(named: "cardBack") {
                cardBackImage.draw(in: self.bounds)
                return
            }
        }
        
        let roundedRect = UIBezierPath(rect: bounds)
        UIColor.white.setFill()
        roundedRect.fill()
        
        switch number! {
        case SetCard.Number.one :
            let rect = CGRect(x: bounds.origin.x + contentWidthMargin, y: bounds.midY - contentHeight/2,  width: bounds.width - contentWidthMargin * 2, height: contentHeight)
            drawContent(rect: rect , shape: shape!, color: color!, shade: shade!)
        case SetCard.Number.two :
            let rect1 = CGRect(x: bounds.origin.x + contentWidthMargin, y: bounds.midY - contentHeight/2 - contentHeight,  width: bounds.width - contentWidthMargin * 2, height: contentHeight)
            let rect2 = CGRect(x: bounds.origin.x + contentWidthMargin, y: bounds.midY + contentHeight/2,  width: bounds.width - contentWidthMargin * 2, height: contentHeight)
            drawContent(rect: rect1, shape: shape!, color: color!, shade: shade!)
            drawContent(rect: rect2, shape: shape!, color: color!, shade: shade!)
        case SetCard.Number.three :
            let rect1 = CGRect(x: bounds.origin.x + contentWidthMargin, y: bounds.midY - contentHeight * 2,  width: bounds.width - contentWidthMargin * 2, height: contentHeight)
            let rect2 = CGRect(x: bounds.origin.x + contentWidthMargin, y: bounds.midY - contentHeight/2,  width: bounds.width - contentWidthMargin * 2, height: contentHeight)
            let rect3 = CGRect(x: bounds.origin.x + contentWidthMargin, y: bounds.midY + contentHeight,  width: bounds.width - contentWidthMargin * 2, height: contentHeight)
            drawContent(rect: rect1, shape: shape!, color: color!, shade: shade!)
            drawContent(rect: rect2, shape: shape!, color: color!, shade: shade!)
            drawContent(rect: rect3, shape: shape!, color: color!, shade: shade!)
        }
    }
    
    private func drawContent(rect : CGRect, shape : SetCard.Shape, color : SetCard.Color, shade : SetCard.Shade) {
        var path : UIBezierPath
        
        switch shape {
        case SetCard.Shape.oval : path = shapeOval(rect: rect)
        case SetCard.Shape.diamond : path = shapeDiamond(rect: rect)
        case SetCard.Shape.squiggle : path = shapeSquiggle(rect: rect)
        }
        
        switch color {
        case SetCard.Color.red :    UIColor.init(cgColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)).setFill()
                            UIColor.init(cgColor: #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)).setStroke()
        case SetCard.Color.green :  UIColor.init(cgColor: #colorLiteral(red: 0.1568627451, green: 0.8039215686, blue: 0.2549019608, alpha: 1)).setFill()
                            UIColor.init(cgColor: #colorLiteral(red: 0.1568627451, green: 0.8039215686, blue: 0.2549019608, alpha: 1)).setStroke()
        case SetCard.Color.blue :   UIColor.init(cgColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)).setFill()
                            UIColor.init(cgColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)).setStroke()
        }
        
        switch shade {
        case SetCard.Shade.none : break
        case SetCard.Shade.stripe :
            path.fill()
            for n in 0..<20 {
                guard n % 2 == 1 else { continue }
                let clipPath = UIBezierPath(rect: CGRect(x: rect.minX + rect.width*CGFloat(n)/20, y: rect.minY, width: rect.width/20, height: rect.height))
                UIColor.white.setFill()
                clipPath.fill()
            }
        case SetCard.Shade.full : path.fill()
        }
        
        path.lineWidth = strokeWidth
        path.stroke()
    }
    
    private func shapeOval(rect : CGRect) -> UIBezierPath {
        return UIBezierPath(ovalIn: rect)
    }
    
    private func shapeDiamond(rect : CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY)) // left
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY)) // top
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY)) // right
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY)) // bottom
        path.close()
        
        return path
    }
    
    private func shapeSquiggle(rect : CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let p1 = CGPoint(x: rect.minX + rect.size.width/6, y: rect.minY + rect.size.height/6)
        let p2 = CGPoint(x: rect.maxX - rect.size.width/6, y: rect.minY + rect.size.height/6)
        let p3 = CGPoint(x: rect.maxX - rect.size.width/6, y: rect.maxY - rect.size.height/6)
        let p4 = CGPoint(x: rect.minX + rect.size.width/6, y: rect.maxY - rect.size.height/6)
        
        path.move(to: p1)
        path.addCurve(to: p2, controlPoint1: CGPoint(x: rect.minX + rect.width/2, y: rect.minY - rect.height/2), controlPoint2: CGPoint(x: rect.maxX - rect.width/2, y: rect.midY + rect.height/5))
        path.addQuadCurve(to: p3, controlPoint: CGPoint(x: rect.maxX - rect.width/20, y: rect.midY))
        path.addCurve(to: p4, controlPoint1: CGPoint(x: rect.maxX - rect.width/2, y: rect.maxY + rect.height/2), controlPoint2: CGPoint(x: rect.minX + rect.width/2, y: rect.midY - rect.height/5))
        path.addQuadCurve(to: p1, controlPoint: CGPoint(x: rect.minX + rect.width/20, y: rect.midY))
        
        return path
    }
    
}

extension CardView {
    private struct SizeRatio {
        static var cornerRadiusToBoundsHeight : CGFloat = 0.06
        static var lineWidth : CGFloat = 0.02
        static var margin : CGFloat = 0.15
        static var contentsHeightRatio : CGFloat = 0.2
    }
    
    private var cardCornerRadius : CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var strokeWidth : CGFloat {
        return min(bounds.size.height, bounds.size.width) * SizeRatio.lineWidth
    }
    
    private var contentWidthMargin : CGFloat {
        return bounds.size.width * SizeRatio.margin
    }
    
    private var contentHeightMargin : CGFloat {
        return bounds.size.height * SizeRatio.margin
    }
    
    private var contentHeight : CGFloat {
        return bounds.size.width * SizeRatio.contentsHeightRatio
    }
}
