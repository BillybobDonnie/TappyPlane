//
//  GameScene.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 7/28/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    struct PhysicsCategory {
        static let Plane: UInt32    = 0
        static let Ground: UInt32   = 0b1
    }
    
    var world: SKNode!
    var player: Plane!
    
    let minFPS: NSTimeInterval = 10/60
    
    var background: ScrollingLayer!
    var foreground: ScrollingLayer!
    
    var lastCallTime: NSTimeInterval = 0
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 213/255.0, green: 237/255.0, blue: 247/255.0, alpha: 1.0)
        
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
        background.position = CGPointMake(0, 30)
        background.horizontalScrollingSpeed = -60
        background.scrolling = true
        world.addChild(background)
        
        // setup foreground
        foreground = ScrollingLayer(tileSpriteNodes: [generateGroundTile(), generateGroundTile(), generateGroundTile()])
        foreground.position = CGPointZero
        foreground.horizontalScrollingSpeed = -80
        foreground.scrolling = true
        world.addChild(foreground)
        
        player = Plane()
        player.position = CGPointMake(self.size.width/2, self.size.height/2)
        player.physicsBody?.affectedByGravity = false
        world.addChild(player)
        
        player.engineRunning = true
    }
    
    func generateGroundTile() -> SKSpriteNode {
        let graphics = SKTextureAtlas(named: "Graphics")
        let sprite = SKSpriteNode(texture: graphics.textureNamed("groundGrass"))
        sprite.anchorPoint = CGPointZero
        
        let offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
        let offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
        
        let path: CGMutablePathRef = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, nil, 403 - offsetX, 17 - offsetY);
        CGPathAddLineToPoint(path, nil, 373 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(path, nil, 316 - offsetX, 25 - offsetY);
        CGPathAddLineToPoint(path, nil, 282 - offsetX, 9 - offsetY);
        CGPathAddLineToPoint(path, nil, 236 - offsetX, 14 - offsetY);
        CGPathAddLineToPoint(path, nil, 219 - offsetX, 29 - offsetY);
        CGPathAddLineToPoint(path, nil, 186 - offsetX, 28 - offsetY);
        CGPathAddLineToPoint(path, nil, 175 - offsetX, 21 - offsetY);
        CGPathAddLineToPoint(path, nil, 126 - offsetX, 33 - offsetY);
        CGPathAddLineToPoint(path, nil, 77 - offsetX, 31 - offsetY);
        CGPathAddLineToPoint(path, nil, 43 - offsetX, 12 - offsetY);
        CGPathAddLineToPoint(path, nil, 1 - offsetX, 18 - offsetY);
        
        sprite.physicsBody = SKPhysicsBody(edgeChainFromPath: path)
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        
        return sprite
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
        foreground.update(timeElapsed)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
