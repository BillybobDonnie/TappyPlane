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
    let maxAltitude: CGFloat = 300
    
    var puffTrailEmitter: SKEmitterNode?
    var puffTrailBirthRate: CGFloat?
    
    var crashTintAction: SKAction!
    
    var planeAnimations: [SKAction]!
    var accelerating = false
    var crashed = false {
        didSet {
            self.accelerating = false
            self.engineRunning = false
        }
    }
    var engineRunning = false {
        didSet {
            if engineRunning {
                puffTrailEmitter?.targetNode = self.parent
                self.actionForKey(keyPlaneAnimation)?.speed = 1.0
                if let particleBirthRate = puffTrailBirthRate {
                    puffTrailEmitter?.particleBirthRate = particleBirthRate
                }
            } else {
                self.actionForKey(keyPlaneAnimation)?.speed = 0.0
                puffTrailEmitter?.particleBirthRate = 0.0
            }
        }
    }
    
    init() {
        let texture = SKTexture(imageNamed: "planeBlue1")
        super.init(texture: texture, color: nil, size: texture.size())
        
        let offsetX = self.frame.size.width * self.anchorPoint.x;
        let offsetY = self.frame.size.height * self.anchorPoint.y;
        
        let path: CGMutablePathRef = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, nil, 41 - offsetX, 21 - offsetY);
        CGPathAddLineToPoint(path, nil, 36 - offsetX, 25 - offsetY);
        CGPathAddLineToPoint(path, nil, 36 - offsetX, 34 - offsetY);
        CGPathAddLineToPoint(path, nil, 11 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(path, nil, 2 - offsetX, 30 - offsetY);
        CGPathAddLineToPoint(path, nil, 2 - offsetX, 22 - offsetY);
        CGPathAddLineToPoint(path, nil, 11 - offsetX, 11 - offsetY);
        CGPathAddLineToPoint(path, nil, 10 - offsetX, 4 - offsetY);
        CGPathAddLineToPoint(path, nil, 26 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, nil, 40 - offsetX, 9 - offsetY);
        
        CGPathCloseSubpath(path);
        
        self.physicsBody = SKPhysicsBody(polygonFromPath: path)
        self.physicsBody?.categoryBitMask = GameScene.PhysicsCategory.Plane
        self.physicsBody?.contactTestBitMask = GameScene.PhysicsCategory.Ground | GameScene.PhysicsCategory.Collectable
        self.physicsBody?.collisionBitMask = GameScene.PhysicsCategory.Ground
        
        self.physicsBody?.mass = 0.08
        
        planeAnimations = []
        
        let plistPath = NSBundle.mainBundle().pathForResource("PlaneAnimations", ofType: "plist")
        
        if let path = plistPath {
            if let animations = NSDictionary(contentsOfFile: path) {
                for (planeColor, textureNames) in animations {
                    planeAnimations.append(animationFromArray(textureNames as! [String], duration: 0.4))
                }
            }
        }
        
        // puff trail particle effect
        if let particleFile = NSBundle.mainBundle().pathForResource("PlanePuffTrail", ofType: "sks") {
            if let emitterNode = NSKeyedUnarchiver.unarchiveObjectWithFile(particleFile) as? SKEmitterNode {
                puffTrailEmitter = emitterNode
                puffTrailEmitter!.position = CGPointMake(-self.size.width/2, -10)
                self.addChild(puffTrailEmitter!)
                puffTrailBirthRate = puffTrailEmitter?.particleBirthRate
                puffTrailEmitter?.particleBirthRate = 0
            }
        }
        
        // setup action to tint plane when it crashes
        let tint = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.8, duration: 0.0)
        let removeTint = SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.2)
        crashTintAction = SKAction.sequence([tint, removeTint])
        
        setRandomColor()
    }
    
    func collide(body: SKPhysicsBody) {
        if !crashed {
            if body.categoryBitMask == GameScene.PhysicsCategory.Ground {
                // Hit the ground
                crashed = true
                self.runAction(crashTintAction)
            } else if body.categoryBitMask == GameScene.PhysicsCategory.Collectable {
                if let collectable = body.node as? Collectable {
                    collectable.collect()
                }
            }
        }
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
    
    func update() {
        if accelerating && self.position.y < maxAltitude {
            self.physicsBody?.applyForce(CGVectorMake(0, 100))
        }
        
        if !crashed {
            // limit rotation to 1 radian
            self.zRotation = fmax(fmin(self.physicsBody!.velocity.dy, 400), -400)/400
        }
    }
    
    func reset() {
        self.crashed = false
        self.engineRunning = true
        self.zRotation = 0
        self.physicsBody?.velocity = CGVectorMake(0, 0)
        self.physicsBody?.angularVelocity = 0
        
        setRandomColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
