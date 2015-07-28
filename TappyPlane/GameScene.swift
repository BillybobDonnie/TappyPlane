//
//  GameScene.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 7/28/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var world: SKNode!
    var player: Plane!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        world = SKNode()
        addChild(world)
        
        player = Plane()
        player.position = CGPointMake(self.size.width/2, self.size.height/2)
        world.addChild(player)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
