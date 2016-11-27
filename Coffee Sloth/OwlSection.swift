//
//  File.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 13/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit




/*  playerSeen, position,
*
*
*
*/

class Owl: SKSpriteNode {
    
    static let orbitalRadius = screenBounds.height / 3
    static let attackVelocity: CGFloat = 100
    static let attackRange: CGFloat = screenBounds.height * 0.8
    static let maxFollowTime: CFTimeInterval = 10
    
    var playerSeen = false
    var alive = true
    var actualPosition: CGPoint = CGPoint(x: -500, y: -500)
    var orbitalStepper: CGFloat = 0
    var followCounter: CFTimeInterval = 0
    
    var accelerationAnimation: SKAction!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        
        
        let owlTexture1 = SKTexture(imageNamed: "devil1")
        let owlTexture2 = SKTexture(imageNamed: "devil2")
        let owlTexture3 = SKTexture(imageNamed: "devil3")
        
        let movingTextures = [owlTexture1, owlTexture2, owlTexture1, owlTexture3]
        
        for e in movingTextures {
            e.filteringMode = .nearest
        }
        
        let movingAnimation = SKAction.animate(with: movingTextures, timePerFrame: 0.3)
        accelerationAnimation = SKAction.repeatForever(movingAnimation)
        
        super.init(texture: owlTexture1, color: UIColor.clear, size: owlTexture1.size())
        
        self.zPosition = 2 // Placed on top of sloth on intersection
        self.position = CGPoint(x: screenBounds.height / 2 + Owl.orbitalRadius, y: screenBounds.height / 2)
        
        self.setScale(1.6)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: owlTexture1.size().height/2.5)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.allowsRotation = false // Maybe reconsider this for smoother animations
        
        self.physicsBody?.categoryBitMask = enemyCategory
        self.physicsBody?.contactTestBitMask = slothCategory
        self.physicsBody?.collisionBitMask = slothCategory
        
        self.run(accelerationAnimation)
        
        
    }

    
    func update(_ time: CFTimeInterval, slothPosition: CGPoint, sectionPosition: CGPoint) {
        
        let t = CGFloat(time)
        let actualOwlPosition = (self.position + sectionPosition)
        actualPosition = actualOwlPosition

        let distance = (slothPosition - actualOwlPosition).length()
        
        if !alive {
            return
        }
        
        if (distance <= Owl.attackRange && !playerSeen) {
            playerSeen = true
            AudioPlayer.playOwlSound()
            // Owl sound should be at this point
        }
        
        if (playerSeen && followCounter < Owl.maxFollowTime) {
            let rot = angleBetweenPoints(actualOwlPosition, second: slothPosition)
            let vel = velocityVector(rot)
            self.position.x += vel.dx * t
            self.position.y += vel.dy * t
            followCounter += time
            if (followCounter >= Owl.maxFollowTime) {
                // Derp
                
                followCounter = 0
                removeFromParent()
            }
        } else {
            self.position.x = screenBounds.height / 2 + cos(orbitalStepper) * Owl.orbitalRadius
            self.position.y = screenBounds.height / 2 + sin(orbitalStepper) * Owl.orbitalRadius
            
            orbitalStepper += 3 * t
            if (orbitalStepper >= CGFloat(2 * M_PI)) {
                orbitalStepper = orbitalStepper - CGFloat(2 * M_PI)
            }
        }
        
    }
    
    func kill() {
        
        alive = false
        let path = Bundle.main.path(forResource: "fireparticle", ofType: "sks")
        let fireparticle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        
        fireparticle.position = CGPoint(x: 0, y: -self.size.height / 2)
        fireparticle.name = "fireparticle"
        fireparticle.targetNode = self.scene
        fireparticle.zPosition = 10000
        self.addChild(fireparticle)
        
        self.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 0.3),
                SKAction.removeFromParent(),
            ])
        )
        
        fireparticle.run(
            SKAction.sequence([
                SKAction.wait(forDuration: 0.3),
                SKAction.removeFromParent(),
                ])
        )
        
    }
    
    
    func velocityVector(_ rotation: CGFloat) -> CGVector {
        let x = cos(rotation) * Owl.attackVelocity
        let y = sin(rotation) * Owl.attackVelocity
        return CGVector(dx: x, dy: y)
    }
    
    
    
}

class OwlSection: Section {
    
    
    static var sloth: Sloth!
    var owl: Owl!
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(sloth: Sloth) {
        
        OwlSection.sloth = sloth
        self.init()
        
        
    }
    
    override init() {
        owl = Owl()
        
        super.init()
        
        self.sectionType = "OwlSection"
        
        
        self.width = 1000
        self.weight = 3
        
        self.addChild(owl)
    }
    
    override func update(_ time: CFTimeInterval) {
        if !children.isEmpty {
            owl.update(time, slothPosition: OwlSection.sloth.sprite.position, sectionPosition: self.position)
    
        }
    }
    
    override func enqueued() {
        removeAllChildren()
        owl = Owl()
        self.addChild(owl)
    }
    
}
