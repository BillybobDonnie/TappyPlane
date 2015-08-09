//
//  GameOverMenu.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 8/9/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class GameOverMenu: SKNode, ButtonDelegate {
    
    enum Medal {
        case None
        case Bronze
        case Silver
        case Gold
    }
    
    var score: Int! {
        didSet {
            scoreText.text = "\(score)"
        }
    }
    var bestScore: Int! {
        didSet {
            bestScoreText.text = "\(bestScore)"
        }
    }
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
    
    var scoreText: BitmapFontLabel!
    var bestScoreText: BitmapFontLabel!
    
    init(size: CGSize) {
        super.init()
        self.size = size
        
        let atlas = SKTextureAtlas(named: "Graphics")
        
        // container for panel elements
        let panelGroup = SKNode()
        self.addChild(panelGroup)
        
        // setup game over title
        let gameOverText = SKSpriteNode(texture: atlas.textureNamed("textGameOver"))
        gameOverText.position = CGPointMake(self.size.width/2, self.size.height - 70)
        self.addChild(gameOverText)
        
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
        
        // setup score text label
        scoreText = BitmapFontLabel(text: "0", fontName: "number")
        scoreText.alignment = .Right
        scoreText.position = CGPointMake(CGRectGetMaxX(scoreTitle.frame), CGRectGetMinY(scoreTitle.frame) - 15)
        scoreText.setScale(0.5)
        panelGroup.addChild(scoreText)
        
        // setup best title
        let bestTitle = SKSpriteNode(texture: atlas.textureNamed("textBest"))
        bestTitle.anchorPoint = CGPointMake(1.0, 1.0)
        bestTitle.position = CGPointMake(CGRectGetMaxX(panelBackground.frame) - 20, CGRectGetMaxY(panelBackground.frame) - 60)
        panelGroup.addChild(bestTitle)
        
        // setup best score text label
        // setup score text label
        bestScoreText = BitmapFontLabel(text: "0", fontName: "number")
        bestScoreText.alignment = .Right
        bestScoreText.position = CGPointMake(CGRectGetMaxX(bestTitle.frame), CGRectGetMinY(bestTitle.frame) - 15)
        bestScoreText.setScale(0.5)
        panelGroup.addChild(bestScoreText)
        
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
        
        // play button
        let playButton = Button(texture: atlas.textureNamed("buttonPlay"))
        playButton.name = "playButton"
        playButton.delegate = self
        playButton.position = CGPointMake(CGRectGetMidX(panelBackground.frame), CGRectGetMinY(panelBackground.frame) - 25)
        self.addChild(playButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ButtonDelegate Methods
    
    func buttonPressed(button: Button) {
        println("button pressed...")
    }
   
}
