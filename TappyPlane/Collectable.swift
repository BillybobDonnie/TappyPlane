//
//  Collectable.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 8/5/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

protocol CollectableDelegate: class {
    func wasCollected(collectable: Collectable)
}

class Collectable: SKSpriteNode {
    weak var delegate: CollectableDelegate?
    var pointValue: Int!
    
    func collect() {
        self.runAction(SKAction.removeFromParent())
        delegate?.wasCollected(self)
    }
}
