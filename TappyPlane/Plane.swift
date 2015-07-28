//
//  Plane.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 7/28/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class Plane: SKSpriteNode {
    
    let keyPlaneAnimation = "PlaneAnimation"
    
    var planeAnimations: [SKAction]!
    var engineRunning = false {
        didSet {
            if engineRunning {
                self.actionForKey(keyPlaneAnimation)?.speed = 1.0
            } else {
                self.actionForKey(keyPlaneAnimation)?.speed = 0.0
            }
        }
    }
    
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
        self.removeActionForKey(keyPlaneAnimation)
        
        self.runAction(planeAnimations[Int(arc4random_uniform(UInt32(planeAnimations.count)))], withKey: keyPlaneAnimation)
        
        if !engineRunning {
            self.actionForKey(keyPlaneAnimation)?.speed = 0.0
        }
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
