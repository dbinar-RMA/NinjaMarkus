//
//  Player.swift
//  SpriteGame
//
//  Created by Dominik Binar on 23.10.19.
//  Copyright © 2019 RMA. All rights reserved.
//

import SpriteKit

class Player {
    
    var hearts: Array<SKSpriteNode>
    var sNode: SKSpriteNode
    var game: gameScene?
    
    init(name : String) {
        sNode = SKSpriteNode(imageNamed: name)
        hearts = Array()
        sNode.position = CGPoint(x: 40, y: 180)
        addHearts()
    }
    
    func setScene(g: gameScene) {
        game = g
    }
    
    func addHearts() {
        var factor : CGFloat = 0.1
        // todo fix position
        repeat {
            let heart = SKSpriteNode(imageNamed: "heart")
            heart.setScale(0.75)
            heart.position.x = 90 * factor
            heart.position.y = 360            
            factor += 0.2;
            hearts.append(heart)
            
            // TODO add parent to heart
            //self.game?.addChild(heart)
            
        } while hearts.count < 10
    }
}
