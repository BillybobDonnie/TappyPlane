//
//  Button.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 8/8/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

protocol ButtonDelegate: class {
    func buttonPressed(button: Button)
}

class Button: SKSpriteNode {
    
    var pressedScale: CGFloat!
    var fullSizeFrame: CGRect!
    
    weak var delegate: ButtonDelegate?
    
    init(texture: SKTexture) {
        super.init(texture: texture, color: nil, size: texture.size())
        pressedScale = 0.9
        self.userInteractionEnabled = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        fullSizeFrame = self.frame
        touchesMoved(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch in touches {
            if CGRectContainsPoint(fullSizeFrame, (touch as! UITouch).locationInNode(self.parent)) {
                self.setScale(pressedScale)
            } else {
                self.setScale(1.0)
            }
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.setScale(1.0)
        for touch in touches {
            if CGRectContainsPoint(fullSizeFrame, (touch as! UITouch).locationInNode(self.parent)) {
                // button pressed
                delegate?.buttonPressed(self)
            }
        }
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        self.setScale(1.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
