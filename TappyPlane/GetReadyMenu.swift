//
//  GetReadyMenu.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 8/10/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class GetReadyMenu: SKNode {
    
    var size: CGSize!
    var getReadyTitle: SKSpriteNode!
    var tapGroup: SKNode!
    
    init(size: CGSize, planePosition: CGPoint) {
        super.init()
        
        self.size = size
        
        let atlas = SKTextureAtlas(named: "Graphics")
        
        getReadyTitle = SKSpriteNode(texture: atlas.textureNamed("textGetReady"))
        getReadyTitle.position = CGPointMake(size.width * 0.75, planePosition.y)
        addChild(getReadyTitle)
        
        tapGroup = SKNode()
        tapGroup.position = planePosition
        addChild(tapGroup)
        
        let rightTapTag = SKSpriteNode(texture: atlas.textureNamed("tapLeft"))
        rightTapTag.position = CGPointMake(55, 0)
        tapGroup.addChild(rightTapTag)
        
        let leftTapTag = SKSpriteNode(texture: atlas.textureNamed("tapRight"))
        leftTapTag.position = CGPointMake(-55, 0)
        tapGroup.addChild(leftTapTag)
        
        let tapAnimationFrames = [
            atlas.textureNamed("tap"),
            atlas.textureNamed("tapTick"),
            atlas.textureNamed("tapTick")
        ]
        
        let tapAnimation = SKAction.animateWithTextures(tapAnimationFrames, timePerFrame: 0.5, resize: true, restore: false)
        
        let tapHand = SKSpriteNode(texture: atlas.textureNamed("tap"))
        tapHand.position = CGPointMake(0, -40)
        tapGroup.addChild(tapHand)
        
        tapHand.runAction(SKAction.repeatActionForever(tapAnimation))
    }
    
    func show() {
        tapGroup.alpha = 1.0
        getReadyTitle.position = CGPointMake(self.size.width * 0.75, getReadyTitle.position.y)
    }
    
    func hide() {
        let fadeTapGroup = SKAction.fadeOutWithDuration(0.5)
        tapGroup.runAction(fadeTapGroup)
        
        let slideLeft = SKAction.moveByX(-30, y: 0, duration: 0.2)
        slideLeft.timingMode = .EaseInEaseOut
        
        let slideRight = SKAction.moveToX(size.width + getReadyTitle.size.width * 0.5, duration: 0.6)
        slideRight.timingMode = .EaseInEaseOut
        
        getReadyTitle.runAction(SKAction.sequence([slideLeft, slideRight]))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
