//
//  ScrollingLayer.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 7/28/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class ScrollingLayer: ScrollingNode {
    
    var rightMostTile: SKSpriteNode?
    
    init(tileSpriteNodes: [SKSpriteNode]) {
        super.init()
        
        for tile in tileSpriteNodes {
            tile.anchorPoint = CGPointZero
            tile.name = "Tile"
            self.addChild(tile)
        }
        
        layoutTiles()
    }
    
    func layoutTiles() {
        rightMostTile = nil
        
        // position tiles one after another
        enumerateChildNodesWithName("Tile") {
            node, _ in
            if let tile = self.rightMostTile {
                node.position = CGPointMake(tile.position.x + tile.size.width, node.position.y)
            } else {
                node.position = CGPointMake(0, node.position.y)
            }
            self.rightMostTile = (node as! SKSpriteNode)
        }
    }
    
    override func update(timeElapsed: NSTimeInterval) {
        super.update(timeElapsed)
        
        // if tile's right edge is left of the scene, move that tile
        // and re-position to right
        if (self.scrolling && self.horizontalScrollingSpeed < 0 && self.scene != nil) {
            enumerateChildNodesWithName("Tile") {
                node, _ in
                let nodePositionInScene = self.convertPoint(node.position, toNode: self.scene!)
                
                if nodePositionInScene.x + node.frame.size.width < -self.scene!.size.width * self.scene!.anchorPoint.x {
                    if let tile = self.rightMostTile {
                        node.position = CGPointMake(tile.position.x + tile.size.width, node.position.y)
                    } else {
                        node.position = CGPointMake(0, node.position.y)
                    }
                    self.rightMostTile = (node as! SKSpriteNode)
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
