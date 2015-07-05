//
//  Sloth.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 25/06/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit

class Sloth {
    
    var sprite: SKSpriteNode!

    
    var boostAnimation: SKAction
    
    var trueVelocity = CGPoint(x: 0, y: 0)
    var acceleration: CGFloat = 0
    let rotationStep: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize) {
        
        
        let slothTexture1 = SKTexture(imageNamed: "sloth1")
        let slothTexture2 = SKTexture(imageNamed: "sloth2")
        let slothTexture3 = SKTexture(imageNamed: "sloth3")
        let slothTexture4 = SKTexture(imageNamed: "sloth4")
        let slothTexture5 = SKTexture(imageNamed: "slothsprite_nofire")
        
        sprite = SKSpriteNode(texture: slothTexture5)
        
        let movingTextures = [slothTexture1, slothTexture2, slothTexture3, slothTexture4]
        for e in movingTextures {
            e.filteringMode = .Nearest
        }
        slothTexture5.filteringMode = .Nearest
        

        
        let movingAnimation = SKAction.animateWithTextures(movingTextures, timePerFrame: 0.1)
        boostAnimation = SKAction.repeatActionForever(movingAnimation)

        sprite.setScale(2.0)
        
        sprite.position = CGPoint(x: 0.2 * size.width, y: 0.7 * size.height)
        acceleration = 0
        trueVelocity = CGPoint(x: 0, y: 0)
        sprite.zRotation = 0
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.height / 2)
        sprite.physicsBody?.dynamic = false
        sprite.physicsBody?.allowsRotation = true

        // Add masks (collision, contact, category)
        
        
        
        
    }
    
    func addBoost() {
        
    }
    
    func stopBoost() {
        
    }
    
    func update(time: CFTimeInterval) {
        
    }
    
    
}