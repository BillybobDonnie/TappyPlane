//
//  Plane.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 7/28/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class Plane: SKSpriteNode {
    
    init() {
        let texture = SKTexture(imageNamed: "planeBlue1")
        super.init(texture: texture, color: nil, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
