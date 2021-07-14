//
//  Card.swift
//  Set
//
//  Created by shin jae ung on 2021/07/08.
//

import Foundation

struct Card : Equatable {
    let color : Color
    let shade : Shade
    let number : Number
    let shape : Shape
}

enum Color {
    case red, green, blue
    static let all = [Color.red, .green, .blue]
}

enum Shade {
    case none, stripe, full
    static let all = [Shade.none, .stripe, .full]
}

enum Number {
    case one, two, three
    static let all = [Number.one, .two, .three]
}

enum Shape {
    case squiggle, diamond, oval
    static let all = [Shape.squiggle, .diamond, .oval]
}
