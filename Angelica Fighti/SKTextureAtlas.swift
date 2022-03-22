//
//  SKTextureAtlas.swift
//  Angelica Fighti
//
//  Created by Pablo  on 4/3/22.
//  Copyright © 2022 P.Cebrian. All rights reserved.
//

import Foundation
import SpriteKit


extension SKTextureAtlas {
    
    func loadAtlas(name: String,prefix:String?)-> [SKTexture] {
    
        var textures:[SKTexture] = []
        let atlas = SKTextureAtlas(named: name)
        for x in atlas.textureNames.sorted(by: { $0 < $1}) {
            if prefix != nil {
                if x.contains(prefix!) {
                    
                    textures.append(atlas.textureNamed(x))
                }
            } else {
                textures.append(atlas.textureNamed(x))
            }
        }
        return textures
    }
}
