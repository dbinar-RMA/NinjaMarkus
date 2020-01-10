//
//  Hearts.swift
//  SpriteGame
//
//  Created by Dominik Binar on 14.10.19.
//  Copyright © 2019 RMA. All rights reserved.
//

import SpriteKit

class Heart {
    
    var heart: SKSpriteNode
    init(x: CGFloat, y: CGFloat) {
        heart = SKSpriteNode(imageNamed: "heart")
        heart.position = CGPoint(x: x, y: y)
    }
}
