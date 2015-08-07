//
//  TilesetTextureProvider.swift
//  TappyPlane
//
//  Created by Atikur Rahman on 8/6/15.
//  Copyright (c) 2015 Atikur Rahman. All rights reserved.
//

import SpriteKit

class TilesetTextureProvider {
    
    static var provider: TilesetTextureProvider!
    var tilesets: [String: [String: SKTexture]]!
    var currentTileset: [String: SKTexture]!
    
    init() {
        loadTilesets()
        randomizeTileset()
    }
    
    class func getProvider() -> TilesetTextureProvider {
        if provider == nil {
            provider = TilesetTextureProvider()
        }
        return provider
    }
    
    func getTextureForKey(key: String) -> SKTexture {
        return currentTileset[key]!
    }
    
    func randomizeTileset() {
        let tilesetKeys: [String] = Array(tilesets.keys)
        let randomIndex = Int(arc4random_uniform(UInt32(tilesetKeys.count)))
        currentTileset = tilesets[tilesetKeys[randomIndex]]
    }
    
    func loadTilesets() {
        tilesets = [String: [String: SKTexture]]()
        let atlas = SKTextureAtlas(named: "Graphics")
        
        let path = NSBundle.mainBundle().pathForResource("TilesetGraphics", ofType: "plist")
        if let tilesetList = NSDictionary(contentsOfFile: path!) {
            for (tilesetKey, textureList) in tilesetList {
                var textures = [String: SKTexture]()
                if let textureList = textureList as? [String: String] {
                    for (textureKey, textureName) in textureList {
                        let texture = atlas.textureNamed(textureName)
                        textures[textureKey] = texture
                    }
                }
                
                if !textures.isEmpty {
                    tilesets[tilesetKey as! String] = textures
                }
            }
        }
    }
}
