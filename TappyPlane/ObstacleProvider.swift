//
//  ObstacleProvider.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 8/8/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class ObstacleProvider {
    
    struct Obstacle {
        var key: ObstacleLayer.Obstacle
        var position: CGPoint
    }
    
    static var provider: ObstacleProvider!
    var obstacleSets: [[Obstacle]]!
    
    init() {
        loadObstacles()
    }
    
    class func getProvider() -> ObstacleProvider {
        if provider == nil {
            provider = ObstacleProvider()
        }
        return provider
    }
    
    func getRandomObstacleSet() -> [Obstacle] {
        return obstacleSets[Int(arc4random_uniform(UInt32(obstacleSets.count)))]
    }
    
    func loadObstacles() {
        obstacleSets = []
        
        var obstacleSet = [Obstacle]()
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.MOUNTAIN_UP, position: CGPointMake(0, 105)))
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.MOUNTAIN_DOWN, position: CGPointMake(143, 250)))
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.COLLECTABLE_STAR, position: CGPointMake(23, 290)))
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.COLLECTABLE_STAR, position: CGPointMake(128, 35)))
        obstacleSets.append(obstacleSet)
        
        obstacleSet = [Obstacle]()
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.MOUNTAIN_UP, position: CGPointMake(90, 25)))
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.MOUNTAIN_DOWN, position: CGPointMake(0, 232)))
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.COLLECTABLE_STAR, position: CGPointMake(100, 242)))
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.COLLECTABLE_STAR, position: CGPointMake(152, 205)))
        obstacleSets.append(obstacleSet)
        
        obstacleSet = [Obstacle]()
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.MOUNTAIN_UP, position: CGPointMake(0, 82)))
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.MOUNTAIN_UP, position: CGPointMake(122, 0)))
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.MOUNTAIN_DOWN, position: CGPointMake(85, 320)))
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.COLLECTABLE_STAR, position: CGPointMake(10, 213)))
        obstacleSet.append(Obstacle(key: ObstacleLayer.Obstacle.COLLECTABLE_STAR, position: CGPointMake(81, 116)))
        obstacleSets.append(obstacleSet)
    }
    
}
