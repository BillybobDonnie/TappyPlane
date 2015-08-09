//
//  GameScene.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 7/28/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, CollectableDelegate, GameOverMenuDelegate {
    
    struct PhysicsCategory {
        static let Plane: UInt32        = 0
        static let Ground: UInt32       = 0b1
        static let Collectable: UInt32  = 0b10
    }
    
    enum GameState {
        case Ready
        case Running
        case Over
    }
    
    var world: SKNode!
    var player: Plane!
    
    let minFPS: NSTimeInterval = 10/60
    
    var background: ScrollingLayer!
    var foreground: ScrollingLayer!
    var obstacles: ObstacleLayer!
    
    var lastCallTime: NSTimeInterval = 0
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    var bestScore: Int!
    
    var scoreLabel: BitmapFontLabel!
    var gameOverMenu: GameOverMenu!
    var gameState: GameState!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor(red: 213/255.0, green: 237/255.0, blue: 247/255.0, alpha: 1.0)
        
        let graphics = SKTextureAtlas(named: "Graphics")
        
        self.physicsWorld.gravity = CGVectorMake(0, -5.5)
        self.physicsWorld.contactDelegate = self
        
        world = SKNode()
        addChild(world)
        
        var backgroundTiles = [SKSpriteNode]()
        
        // setup background
        for i in 0..<3 {
            let tile = SKSpriteNode(texture: graphics.textureNamed("background"))
            backgroundTiles.append(tile)
        }
        
        background = ScrollingLayer(tileSpriteNodes: backgroundTiles)
        background.position = CGPointMake(0, 30)
        background.horizontalScrollingSpeed = -60
        background.scrolling = true
        world.addChild(background)
        
        // setup obstacles
        obstacles = ObstacleLayer()
        obstacles.collectableDelegate = self
        obstacles.horizontalScrollingSpeed = -80
        obstacles.marker = self.size.width + obstacles.markerBuffer
        obstacles.scrolling = true
        obstacles.floor = 0
        obstacles.ceiling = self.size.height
        world.addChild(obstacles)
        
        // setup foreground
        foreground = ScrollingLayer(tileSpriteNodes: [generateGroundTile(), generateGroundTile(), generateGroundTile()])
        foreground.position = CGPointZero
        foreground.horizontalScrollingSpeed = -80
        foreground.scrolling = true
        world.addChild(foreground)
        
        player = Plane()
        player.position = CGPointMake(self.size.width * 0.3, self.size.height/2)
        player.physicsBody?.affectedByGravity = false
        world.addChild(player)
        
        // setup score label
        scoreLabel = BitmapFontLabel(text: "0", fontName: "number")
        scoreLabel.position = CGPointMake(self.size.width * 0.9, self.size.height - 50)
        addChild(scoreLabel)
        
        // test game over menu
        gameOverMenu = GameOverMenu(size: self.size)
        gameOverMenu.delegate = self
        gameOverMenu.alpha = 0.01   // possible spritekit bug, doesn't work with alpha 0.0
        addChild(gameOverMenu)
        
        bestScore = 0
        
        newGame()
    }
    
    func generateGroundTile() -> SKSpriteNode {
        let graphics = SKTextureAtlas(named: "Graphics")
        let sprite = SKSpriteNode(texture: TilesetTextureProvider.getProvider().getTextureForKey("ground"))
        sprite.anchorPoint = CGPointZero
        
        let offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
        let offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
        
        let path: CGMutablePathRef = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, nil, 403 - offsetX, 17 - offsetY);
        CGPathAddLineToPoint(path, nil, 373 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(path, nil, 316 - offsetX, 25 - offsetY);
        CGPathAddLineToPoint(path, nil, 282 - offsetX, 9 - offsetY);
        CGPathAddLineToPoint(path, nil, 236 - offsetX, 14 - offsetY);
        CGPathAddLineToPoint(path, nil, 219 - offsetX, 29 - offsetY);
        CGPathAddLineToPoint(path, nil, 186 - offsetX, 28 - offsetY);
        CGPathAddLineToPoint(path, nil, 175 - offsetX, 21 - offsetY);
        CGPathAddLineToPoint(path, nil, 126 - offsetX, 33 - offsetY);
        CGPathAddLineToPoint(path, nil, 77 - offsetX, 31 - offsetY);
        CGPathAddLineToPoint(path, nil, 43 - offsetX, 12 - offsetY);
        CGPathAddLineToPoint(path, nil, 1 - offsetX, 18 - offsetY);
        
        sprite.physicsBody = SKPhysicsBody(edgeChainFromPath: path)
        sprite.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        
        return sprite
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PhysicsCategory.Plane {
            player.collide(contact.bodyB)
        } else if contact.bodyB.categoryBitMask == PhysicsCategory.Plane {
            player.collide(contact.bodyA)
        }        
    }
    
    func newGame() {
        TilesetTextureProvider.getProvider().randomizeTileset()
        
        // reset layers
        background.position = CGPointZero
        background.layoutTiles()
        obstacles.position = CGPointZero
        obstacles.reset()
        obstacles.scrolling = false
        foreground.position = CGPointZero
        
        for node in foreground.children {
            if let ground = node as? SKSpriteNode {
                ground.texture = TilesetTextureProvider.getProvider().getTextureForKey("ground")
            }
        }
        
        foreground.layoutTiles()
        
        // reset plane
        player.position = CGPointMake(self.size.width * 0.3, self.size.height/2)
        player.physicsBody?.affectedByGravity = false
        player.reset()
        
        score = 0
        scoreLabel.alpha = 1.0
        
        gameState = .Ready
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if gameState == .Ready {
            player.physicsBody?.affectedByGravity = true
            obstacles.scrolling = true
            gameState = .Running
        }
        
        if gameState == .Running {
            player.accelerating = true
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if gameState == .Running {
            player.accelerating = false
        }
    }
    
    override func update(currentTime: NSTimeInterval) {
        var timeElapsed = currentTime - lastCallTime
        lastCallTime = currentTime
        
        // in case it takes too long (probably first time when scene loads)
        if timeElapsed > minFPS {
            timeElapsed = minFPS
        }
        
        player.update()
        
        if gameState == .Running && player.crashed {
            gameState = .Over
            scoreLabel.runAction(SKAction.fadeOutWithDuration(0.4))
            gameOverMenu.alpha = 1.0
            gameOverMenu.score = score
            gameOverMenu.medal = getMedalForCurrentScore(score)
            if score > bestScore {
                bestScore = score
            }
            gameOverMenu.bestScore = bestScore
            gameOverMenu.show()
        }
        
        if gameState != .Over {
            background.update(timeElapsed)
            obstacles.update(timeElapsed)
            foreground.update(timeElapsed)
        }
    }
    
    func getMedalForCurrentScore(score: Int) -> GameOverMenu.Medal {
        let adjustedScore = score - bestScore/5
        
        if adjustedScore >= 45 {
            return .Gold
        } else if adjustedScore >= 25 {
            return .Silver
        } else if adjustedScore >= 10 {
            return .Bronze
        } else {
            return .None
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CollectableDelegate Methods
    
    func wasCollected(collectable: Collectable) {
        score += collectable.pointValue
    }
    
    // MARK: - GameOverMenuDelegate Methods
    
    func pressedStartNewGameButton() {
        newGame()
        gameOverMenu.alpha = 0.0
        gameOverMenu.playButton.userInteractionEnabled = false
    }
    
}
