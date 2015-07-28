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
    
    let minFPS: NSTimeInterval = 10/60
    
    var background: ScrollingLayer!
    var lastCallTime: NSTimeInterval = 0
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let graphics = SKTextureAtlas(named: "Graphics")
        
        self.physicsWorld.gravity = CGVectorMake(0, -5.5)
        
        world = SKNode()
        addChild(world)
        
        var backgroundTiles = [SKSpriteNode]()
        
        // setup background
        for i in 0..<3 {
            let tile = SKSpriteNode(texture: graphics.textureNamed("background"))
            backgroundTiles.append(tile)
        }
        
        background = ScrollingLayer(tileSpriteNodes: backgroundTiles)
        background.position = CGPointZero
        background.horizontalScrollingSpeed = -60
        background.scrolling = true
        world.addChild(background)
        
        player = Plane()
        player.position = CGPointMake(self.size.width/2, self.size.height/2)
        player.physicsBody?.affectedByGravity = false
        world.addChild(player)
        
        player.engineRunning = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches {
            player.physicsBody?.affectedByGravity = true
            player.accelerating = true
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches {
            player.accelerating = false
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        var timeElapsed = currentTime - lastCallTime
        lastCallTime = currentTime
        
        // in case it takes too long (probably first time when scene loads)
        if timeElapsed > minFPS {
            timeElapsed = minFPS
        }
        
        player.update()
        background.update(timeElapsed)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
