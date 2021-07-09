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

enum Color : Int {
    case red = 0
    case green = 1
    case blue = 2
}

enum Shade : Int {
    case none = 0
    case half = 1
    case full = 2
}

enum Number : Int {
    case one = 0
    case two = 1
    case three = 2
}

enum Shape : Int {
    case triangle = 0
    case square = 1
    case circle = 2
}
