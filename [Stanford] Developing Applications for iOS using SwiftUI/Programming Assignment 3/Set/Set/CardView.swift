//
//  CardView.swift
//  Set
//
//  Created by Shin Jae Ung on 2022/04/20.
//

import SwiftUI

struct CardView: View {
    let format: CardShapeFormat
    let number: CardShapeNumber
    let color: CardShapeColor
    let shade: CardShapeShade
    let isSelected: Bool
    let hint: Bool
    
    init(_ card: SetGame.Card, isSelected: Bool, hint: Bool) {
        self.format = card.format
        self.number = card.number
        self.color = card.color
        self.shade = card.shade
        self.isSelected = isSelected
        self.hint = hint
    }
    
    private var shapeColor: Color {
        switch color {
        case .red: return .red
        case .green: return .green
        case .blue: return .blue
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let lineWidth = min(geometry.size.width, geometry.size.height)/50
            let cornerRadius = min(geometry.size.width, geometry.size.height)/10
            ZStack{
                switch self.shade {
                case .none:
                    CardShape(format: self.format, number: self.number)
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(self.shapeColor)
                case .stripe:
                    CardShape(format: self.format, number: self.number)
                        .foregroundColor(self.shapeColor)
                    VStack(spacing: 0) {
                        ForEach (0..<20) { number in
                            Color.clear
                            Color(uiColor: .systemBackground)
                            if number == 19 {
                                Color.clear
                            }
                        }
                    }
                    CardShape(format: self.format, number: self.number)
                        .stroke(lineWidth: lineWidth)
                        .foregroundColor(self.shapeColor)
                case .fill:
                    CardShape(format: self.format, number: self.number)
                        .stroke(lineWidth: lineWidth)
                        .background(CardShape(format: self.format, number: self.number).fill())
                        .foregroundColor(self.shapeColor)
                }
            }
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: lineWidth)
                .foregroundColor(
                    self.hint ? Color.red :
                        self.isSelected ? Color.blue : Color(uiColor: .label)
                )
        }
    }
}

struct CardShape: Shape {
    let format: CardShapeFormat
    let number: CardShapeNumber
    var pathClosure: (CGRect) -> Path {
        switch self.format {
        case .diamond: return diamondPath(in:)
        case .squiggle: return squigglePath(in:)
        case .oval: return ovalPath(in:)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width/3 - rect.width/10
        let height = rect.height
        
        var path = Path()
        switch number {
        case .one:
            let rect1 = CGRect(x: rect.maxX/3 + rect.width/20, y: 0, width: width, height: height)
            path.addPath(self.pathClosure(rect1))
        case .two:
            let rect1 = CGRect(x: rect.maxX/6 + rect.width/20, y: 0, width: width, height: height)
            let rect2 = CGRect(x: rect.maxX/2 + rect.width/20, y: 0, width: width, height: height)
            path.addPath(self.pathClosure(rect1))
            path.addPath(self.pathClosure(rect2))
        case .three:
            let rect1 = CGRect(x: rect.minX + rect.width/10, y: 0, width: width, height: height)
            let rect2 = CGRect(x: rect.maxX/3 + rect.width/20, y: 0, width: width, height: height)
            let rect3 = CGRect(x: rect.maxX*2/3, y: 0, width: width, height: height)
            path.addPath(self.pathClosure(rect1))
            path.addPath(self.pathClosure(rect2))
            path.addPath(self.pathClosure(rect3))
        }
        
        return path
    }
    
    func diamondPath(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + height/12))
        path.addLine(to: CGPoint(x: rect.minX + width/8, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY - height/12))
        path.addLine(to: CGPoint(x: rect.maxX - width/8, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + height/12))
        
        return path
    }
    
    func ovalPath(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: rect.minX + width/6, y: rect.minY + height/4))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.minY + height/4), radius: width/2 - width/6, startAngle: Angle(degrees: -180), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - width/6, y: rect.maxY - height/4))
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY - height/4), radius: width/2 - width/6, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 180), clockwise: false)
        path.closeSubpath()
        
        return path
    }
    
    func squigglePath(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let p1 = CGPoint(x: rect.minX + width/5, y: rect.maxY - height/5)
        let p2 = CGPoint(x: rect.minX + width/5, y: rect.minY + height/5)
        let p3 = CGPoint(x: rect.maxX - width/5, y: rect.minY + height/5)
        let p4 = CGPoint(x: rect.maxX - width/5, y: rect.maxY - height/5)
        
        path.move(to: p1)
        path.addCurve(
            to: p2,
            control1: CGPoint(x: p1.x - width/4, y: rect.midY + height/8),
            control2: CGPoint(x: p1.x + width/3, y: rect.midY)
        )
        path.addQuadCurve(to: p3, control: CGPoint(x: rect.minX + width/6, y: rect.minY + height/40))
        path.addCurve(
            to: p4,
            control1: CGPoint(x: p3.x + width/4, y: rect.midY - height/8),
            control2: CGPoint(x: p3.x - width/3, y: rect.midY)
        )
        path.addQuadCurve(to: p1, control: CGPoint(x: rect.maxX - width/6, y: rect.maxY - height/40))
        
        return path
    }
}

struct CardView_Previews: PreviewProvider {
    static let width: CGFloat = 25 * 3
    static let height: CGFloat = 15.5 * 3
    
    static var previews: some View {
        let card = SetGame.Card(color: .red, number: .three, format: .squiggle, shade: .stripe, id: 1)
        
        VStack {
            CardView(card, isSelected: true, hint: true)
            CardView(card, isSelected: true, hint: false)
            CardView(card, isSelected: false, hint: false)
        }
        .padding()
    }
}
