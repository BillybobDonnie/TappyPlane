//
//  ObstacleLayer.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 7/29/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class ObstacleLayer: ScrollingNode {
    
    enum Obstacle {
        case MOUNTAIN_UP
        case MOUNTAIN_DOWN
        case COLLECTABLE_STAR
        
        func getKey() -> String {
            switch self {
            case .MOUNTAIN_UP: return "MountainUp"
            case .MOUNTAIN_DOWN: return "MountainDown"
            case .COLLECTABLE_STAR: return "CollectableStar"
            }
        }
    }
    
    var marker: CGFloat!
    
    let markerBuffer: CGFloat = 200
    let verticalGap: CGFloat = 90
    let spaceBetweenObstacleSets: CGFloat = 180
    var floor: CGFloat!
    var ceiling: CGFloat!
    
    func reset() {
        // loop through child nodes and reposition for reuse
        for node in self.children {
            if let node = node as? SKNode {
                node.position = CGPointMake(-1000, 0)
            }
        }
        
        if (self.scene != nil) {
            marker = self.scene!.size.width + markerBuffer
        }
    }
    
    override func update(timeElapsed: NSTimeInterval) {
        super.update(timeElapsed)
        
        if scrolling && self.scene != nil {
            // find marker's location in scene coordinate system
            let markerLocationInScene = self.convertPoint(CGPointMake(self.marker, 0), toNode: self.scene!)
            // when marker comes onto screen, add new obstacles
            if markerLocationInScene.x - (self.scene!.size.width * self.scene!.anchorPoint.x) < self.scene!.size.width + markerBuffer {
                addObstacleSet()
            }
        }
    }
    
    func addObstacleSet() {
        let mountainUp = getUnusedObject(.MOUNTAIN_UP)
        let mountainDown = getUnusedObject(.MOUNTAIN_DOWN)
        
        let maxVariation = (mountainUp.size.height + mountainDown.size.height + verticalGap) - (ceiling - floor)
        let yAdjustment = CGFloat(arc4random_uniform(UInt32(maxVariation)))
        
        mountainUp.position = CGPointMake(marker, floor + mountainUp.size.height/2 - yAdjustment)
        mountainDown.position = CGPointMake(marker, mountainUp.position.y + mountainDown.size.height + verticalGap)
        
        marker = marker + spaceBetweenObstacleSets
    }
    
    func getUnusedObject(obstacle: Obstacle) -> SKSpriteNode {
        if self.scene != nil {
            // get left edge of screen in local coordinates
            let leftEdgeInLocalCoords = self.scene!.convertPoint(CGPointMake(-self.scene!.size.width * self.scene!.anchorPoint.x, 0), toNode: self).x
            
            // try ton find object of mountainType to the left of the screen
            for node in self.children {
                if let node = node as? SKSpriteNode {
                    if node.name == obstacle.getKey() && node.frame.origin.x + node.frame.size.width < leftEdgeInLocalCoords {
                        return node
                    }
                }
            }
        }
        
        // couldn't find an unused node of mountainType, so create new one
        return createObject(obstacle)
    }
    
    func createObject(obstacle: Obstacle) -> SKSpriteNode {
        let graphics = SKTextureAtlas(named: "Graphics")
        
        var object = SKSpriteNode()
        
        if obstacle == Obstacle.MOUNTAIN_UP {
            object = SKSpriteNode(texture: graphics.textureNamed("MountainGrass"))
            
            let offsetX = object.frame.size.width * object.anchorPoint.x;
            let offsetY = object.frame.size.height * object.anchorPoint.y;
            
            let path = CGPathCreateMutable();
            
            CGPathMoveToPoint(path, nil, 55 - offsetX, 199 - offsetY);
            CGPathAddLineToPoint(path, nil, 0 - offsetX, 2 - offsetY);
            CGPathAddLineToPoint(path, nil, 90 - offsetX, 1 - offsetY);
            CGPathCloseSubpath(path)
            
            object.physicsBody = SKPhysicsBody(edgeLoopFromPath: path)
            object.physicsBody?.categoryBitMask = GameScene.PhysicsCategory.Ground
            
            addChild(object)
        } else if obstacle == Obstacle.MOUNTAIN_DOWN {
            object = SKSpriteNode(texture: graphics.textureNamed("MountainGrassDown"))
            
            let offsetX = object.frame.size.width * object.anchorPoint.x;
            let offsetY = object.frame.size.height * object.anchorPoint.y;
            
            let path = CGPathCreateMutable();
            
            CGPathMoveToPoint(path, nil, 1 - offsetX, 199 - offsetY);
            CGPathAddLineToPoint(path, nil, 89 - offsetX, 198 - offsetY);
            CGPathAddLineToPoint(path, nil, 55 - offsetX, 0 - offsetY);
            CGPathCloseSubpath(path);
            
            object.physicsBody = SKPhysicsBody(edgeLoopFromPath: path)
            object.physicsBody?.categoryBitMask = GameScene.PhysicsCategory.Ground
            
            addChild(object)
        }
        
        object.name = obstacle.getKey()
        
        return object
    }
}