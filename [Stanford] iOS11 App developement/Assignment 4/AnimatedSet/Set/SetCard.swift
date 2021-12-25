//
//  Card.swift
//  Set
//
//  Created by shin jae ung on 2021/07/08.
//

import Foundation

struct SetCard : Equatable {
    let color : Color
    let shade : Shade
    let number : Number
    let shape : Shape
    
    enum Color: CaseIterable {
        case red, green, blue
    }

    enum Shade: CaseIterable {
        case none, stripe, full
    }

    enum Number: CaseIterable {
        case one, two, three
    }

    enum Shape: CaseIterable {
        case squiggle, diamond, oval
    }
}


