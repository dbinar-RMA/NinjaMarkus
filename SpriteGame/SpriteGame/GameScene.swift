//
//  GameScene.swift
//  SpriteGame
//
//  Created by Dominik Binar on 09.10.19.
//  Copyright © 2019 RMA. All rights reserved.
//

import SpriteKit


// operator overrides
func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}
#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

// CGPoint extension
extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    func normalized() -> CGPoint {
        return self / length()
    }
}

// physics struct
struct PhysicsCategory {
    static let none         : UInt32 = 0
    static let all          : UInt32 = UInt32.max
    static let monster      : UInt32 = 0b1          // 1st bit = monster
    static let projectile   : UInt32 = 0b10         // 2nd bit = projectile
}


// MAIN GAME CLASS
class gameScene: SKScene {
    
    var player: Player = Player(name: "player")
    var monstersDestroyed = 0
    var label = Info(attributes: SKLabelNode(fontNamed: "Courier"))
    
    public init(s : CGSize) {
        super.init(size: s)
        player.setScene(g: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("dsgd")
    }
    
    override func didMove(to view: SKView) {
    
        // set background & info
        backgroundColor = SKColor.lightGray
        label.setValues(text: "Philipps: 20", size: 25, color: SKColor.darkGray, position: CGPoint(x: size.width * 0.7, y: size.height * 0.93))
        label.countdown(clear: true)
        addChild(label.attributes)
  
        // add player
        addChild(player.sNode)
        for h in player.hearts {
            addChild(h)
        }
        
        // set physics
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        // run game
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(game), SKAction.wait(forDuration: 0.5 )])))
        // add Music
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
   
    func game() {
        // add monster
        let m = Monsters(name: "monster", sz: size, game: self, player: player)
        
        addChild(m.mNode)
        m.do_spooks()         
    }
    
    func removePlayerHeart() {
        if player.hearts.count <= 0 {
            // game over
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            view?.presentScene(gameOverScene, transition: reveal)
            self.label.countdown(clear: true)
        }
        else {
            let heart = player.hearts.remove(at: player.hearts.count - 1)
            heart.removeFromParent()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        //run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false)) // doenst work with simulator
        
        let touchLocation = touch.location(in: self)
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = player.sNode.position
        
        // set projectile physics
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width / 2)
        projectile.physicsBody?.isDynamic = true;
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        projectile.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset = touchLocation - projectile.position
        if offset.x < 0 { return }  // touched down or backwards
        addChild(projectile)
        
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + projectile.position
        
        // create actions
        let actMove = SKAction.move(to: realDest, duration: 2.0)
        let actMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actMove, actMoveDone]))
    }
    
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        projectile.removeFromParent()
        monster.removeFromParent()
        
        monstersDestroyed += 1
        self.label.countdown(clear: false)
        
        if monstersDestroyed == 20 {
            // go to next stage
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            view?.presentScene(gameOverScene, transition: reveal)
            self.label.countdown(clear: true)
            player.hearts.removeAll()
        }
    }
}

extension gameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
            
            if let monster = firstBody.node as? SKSpriteNode,
                let projectile = secondBody.node as? SKSpriteNode {
                projectileDidCollideWithMonster(projectile: projectile, monster: monster)
            }
        }
    }
}
