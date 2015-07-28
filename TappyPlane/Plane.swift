//
//  Plane.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 7/28/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class Plane: SKSpriteNode {
    
    var planeAnimations: [SKAction]!
    
    init() {
        let texture = SKTexture(imageNamed: "planeBlue1")
        super.init(texture: texture, color: nil, size: texture.size())
        
        planeAnimations = []
        
        let path = NSBundle.mainBundle().pathForResource("PlaneAnimations", ofType: "plist")
        
        if let path = path {
            if let animations = NSDictionary(contentsOfFile: path) {
                for (planeColor, textureNames) in animations {
                    planeAnimations.append(animationFromArray(textureNames as! [String], duration: 0.4))
                }
            }
        }
        
        setRandomColor()
    }
    
    func setRandomColor() {
        self.runAction(planeAnimations[Int(arc4random_uniform(UInt32(planeAnimations.count)))])
    }
    
    func animationFromArray(textureNames: [String], duration: CGFloat) -> SKAction {
        var frames = [SKTexture]()
        let atlas = SKTextureAtlas(named: "Graphics")
        
        for textureName in textureNames {
            frames.append(atlas.textureNamed(textureName))
        }
        
        let frameTime = duration / CGFloat(frames.count)
        
        return SKAction.repeatActionForever(SKAction.animateWithTextures(frames, timePerFrame: NSTimeInterval(frameTime), resize: false, restore: false))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
