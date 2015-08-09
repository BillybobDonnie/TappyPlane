//
//  GameOverMenu.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 8/9/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class GameOverMenu: SKNode {
    
    enum Medal {
        case None
        case Bronze
        case Silver
        case Gold
    }
    
    var score: Int!
    var bestScore: Int!
    var medal: Medal = .None {
        didSet {
            switch medal {
            case .Bronze:
                medalDisplay.texture = SKTextureAtlas(named: "Graphics").textureNamed("medalBronze")
            case .Silver:
                medalDisplay.texture = SKTextureAtlas(named: "Graphics").textureNamed("medalSilver")
            case .Gold:
                medalDisplay.texture = SKTextureAtlas(named: "Graphics").textureNamed("medalGold")
            case .None:
                medalDisplay.texture = SKTextureAtlas(named: "Graphics").textureNamed("medalBlank")
            }
        }
    }
    var size: CGSize!
    var medalDisplay: SKSpriteNode!
    
    init(size: CGSize) {
        super.init()
        self.size = size
        
        let atlas = SKTextureAtlas(named: "Graphics")
        
        // container for panel elements
        let panelGroup = SKNode()
        self.addChild(panelGroup)
        
        // setup panel background
        let panelBackground = SKSpriteNode(texture: atlas.textureNamed("UIbg"))
        panelBackground.position = CGPointMake(size.width/2, size.height - 150)
        panelBackground.centerRect = CGRectMake(
            10 / panelBackground.size.width,
            10 / panelBackground.size.height,
            (panelBackground.size.width - 20) / panelBackground.size.width,
            (panelBackground.size.height - 20) / panelBackground.size.height)
        panelBackground.xScale = 175.0 / panelBackground.size.width
        panelBackground.yScale = 115.0 / panelBackground.size.height
        panelGroup.addChild(panelBackground)
        
        // setup score title
        let scoreTitle = SKSpriteNode(texture: atlas.textureNamed("textScore"))
        scoreTitle.anchorPoint = CGPointMake(1.0, 1.0)
        scoreTitle.position = CGPointMake(CGRectGetMaxX(panelBackground.frame) - 20, CGRectGetMaxY(panelBackground.frame) - 10)
        panelGroup.addChild(scoreTitle)
        
        // setup best title
        let bestTitle = SKSpriteNode(texture: atlas.textureNamed("textBest"))
        bestTitle.anchorPoint = CGPointMake(1.0, 1.0)
        bestTitle.position = CGPointMake(CGRectGetMaxX(panelBackground.frame) - 20, CGRectGetMaxY(panelBackground.frame) - 60)
        panelGroup.addChild(bestTitle)
        
        // setup medal title
        let medalTitle = SKSpriteNode(texture: atlas.textureNamed("textMedal"))
        medalTitle.anchorPoint = CGPointMake(0.0, 1.0)
        medalTitle.position = CGPointMake(CGRectGetMinX(panelBackground.frame) + 20, CGRectGetMaxY(panelBackground.frame) - 10)
        panelGroup.addChild(medalTitle)
        
        // setup medal display
        medalDisplay = SKSpriteNode(texture: atlas.textureNamed("medalBlank"))
        medalDisplay.anchorPoint = CGPointMake(0.5, 1.0)
        medalDisplay.position = CGPointMake(CGRectGetMidX(medalTitle.frame), CGRectGetMinY(medalTitle.frame) - 15)
        panelGroup.addChild(medalDisplay)        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}
