//
//  BitmapFontLabel.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 8/5/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class BitmapFontLabel: SKNode {
    
    enum Alignment {
        case Left
        case Right
        case Center
    }
    
    var alignment: Alignment = .Center {
        didSet {
            updateText()
        }
    }
    
    var fontName: String! {
        didSet {
            updateText()
        }
    }
    var text: String! {
        didSet {
            updateText()
        }
    }
    var letterSpacing: CGFloat! {
        didSet {
            updateText()
        }
    }
    
    init(text: String, fontName: String) {
        super.init()
        
        self.text = text
        self.fontName = fontName
        self.letterSpacing = 2.0
        
        updateText()
    }
    
    func updateText() {
        // remove unused nodes
        if count(self.text) < self.children.count {
            for var i = self.children.count; i > count(self.text); i-- {
                self.children[i-1].removeFromParent()
            }
        }
        
        var pos = CGPointZero
        var totalSize = CGSizeZero
        let atlas = SKTextureAtlas(named: "Graphics")
        
        for (index,char) in enumerate(self.text) {
            let textureName = "\(self.fontName)\(char)"
            let letter: SKSpriteNode
            
            if index < self.children.count {
                // reuse an existing node
                letter = self.children[index] as! SKSpriteNode
                letter.texture = atlas.textureNamed(textureName)
                letter.size = letter.texture!.size()
            } else {
                // create a new letter node
                letter = SKSpriteNode(texture: atlas.textureNamed(textureName))
                letter.anchorPoint = CGPointZero
                self.addChild(letter)
            }
            
            letter.position = pos
            
            pos.x += letter.size.width + self.letterSpacing
            totalSize.width += letter.size.width + self.letterSpacing
            if totalSize.height < letter.size.height {
                totalSize.height = letter.size.height
            }
        }
        
        if count(self.text) > 0 {
            totalSize.width -= self.letterSpacing
        }
        
        var adjustment: CGPoint
        
        // text alignment
        switch alignment {
        case .Left:
            adjustment = CGPointMake(0, -totalSize.height/2)
        case .Right:
            adjustment = CGPointMake(-totalSize.width, -totalSize.height/2)
        case .Center:
            adjustment = CGPointMake(-totalSize.width/2, -totalSize.height/2)
        }

        for var index = 0; index < self.children.count; index++ {
            var letter = self.children[index] as! SKSpriteNode
            letter.position = CGPointMake(letter.position.x + adjustment.x, letter.position.y + adjustment.y)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
