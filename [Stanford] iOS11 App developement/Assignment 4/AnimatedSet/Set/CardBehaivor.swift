//
//  CardBehaivor.swift
//  Set
//
//  Created by shin jae ung on 2021/12/23.
//

import UIKit

fileprivate extension CGFloat {
    var arc4ramdom: CGFloat {
        return self * CGFloat(arc4random()) / 0xFFFFFFFF
    }
}

final class CardBehaivor: UIDynamicBehavior {
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    
    override init() {
        super.init()
        self.addChildBehavior(self.itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
    
    func add(item: UIDynamicItem) {
        self.itemBehavior.addItem(item)
        self.push(item)
    }
    
    func remove(item: UIDynamicItem) {
        self.itemBehavior.removeItem(item)
    }
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2 * CGFloat.pi).arc4ramdom
        push.magnitude = CGFloat(1.0) + CGFloat(1.0).arc4ramdom
        push.setTargetOffsetFromCenter(UIOffset(horizontal: item.bounds.midX, vertical: item.bounds.midY), for: item)
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        self.addChildBehavior(push)
    }
}
