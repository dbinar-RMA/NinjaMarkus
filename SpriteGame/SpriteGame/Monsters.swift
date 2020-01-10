//
//  Monster.swift
//  SpriteGame
//
//  Created by Dominik Binar on 21.10.19.
//  Copyright © 2019 RMA. All rights reserved.
//

import SpriteKit

class Monsters {
    
    let mNode: SKSpriteNode
    var actions: Array<SKAction> = Array()
    var size: CGSize
    var game: gameScene
    var player: Player
    
    init(name: String, sz: CGSize, game: gameScene, player: Player) {
        mNode = SKSpriteNode(imageNamed: name)
        size = sz
        self.game = game
        self.player = player
        prep_spooks()
    }
    
    // set physics
    func setPhsyics(categoryBitMask: UInt32, contactTestBitMask: UInt32) {
        mNode.physicsBody = SKPhysicsBody(rectangleOf: mNode.size)
        mNode.physicsBody?.isDynamic = true
        mNode.physicsBody?.categoryBitMask = categoryBitMask
        mNode.physicsBody?.contactTestBitMask = contactTestBitMask
        mNode.physicsBody?.collisionBitMask = UInt32(0)    // bump off value
    }
    // define actions
    func prep_spooks() {        
        setPhsyics(categoryBitMask: UInt32(0b1), contactTestBitMask: UInt32(0b10))
        
        var actualY = CGFloat.random(in: mNode.size.height ..< size.height - mNode.size.height / 2)
        
        if actualY > (size.height * 0.9) {
            actualY = size.height * 0.85
        }
        mNode.position = CGPoint(x: size.width + mNode.size.width / 2, y : actualY)
        
        let actualDuration = CGFloat.random(in: CGFloat(2.0) ..< CGFloat(15.0))
        // create actions
        let actMove = SKAction.move(to: CGPoint(x: -mNode.size.width / 2, y: actualY), duration: TimeInterval(actualDuration))
        let actMoveDone = SKAction.removeFromParent()
        
        let loseAction = SKAction.run() {
          
            // passed player
            // tell game to remove heart
            self.game.removePlayerHeart()
        }
        actions.append(actMove)
        actions.append(loseAction)
        actions.append(actMoveDone)
    }
    
    func do_spooks() {
        mNode.run(SKAction.sequence(actions))
    }
}
