//
//  ScrollingNode.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 7/28/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class ScrollingNode: SKNode {
    
    var horizontalScrollingSpeed: CGFloat!
    var scrolling: Bool
    
    override init() {
        scrolling = false
        
        super.init()
    }
    
    func update(timeElapsed: NSTimeInterval) {
        if scrolling {
            self.position = CGPointMake(self.position.x + horizontalScrollingSpeed * CGFloat(timeElapsed), self.position.y)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
