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
    
    
    // GRAPHICS
    
    var sprite: SKSpriteNode!
    var accelerationAnimation: SKAction
    var noAccelerationTexture: SKTexture
    
    
    // MOVEMENTS
    var accelerating = false
    let speedLimit: CGFloat = 500
    // 500
    
    let accelerationForce: CGFloat = 2000
    // 4000
    
    //var accelerationVector = CGPoint(x: 0, y: 0)
    
    var velocityScalar: CGFloat = 0
    var velocity = CGVectorMake(0, 0)
    
    var angularAccelerationScalar: CGFloat = 0
    
    //var rotation: CGFloat = 0
    let rotationStep: CGFloat = 0
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize) {
        
        
        let slothTexture1 = SKTexture(imageNamed: "sloth1")
        let slothTexture2 = SKTexture(imageNamed: "sloth2")
        let slothTexture3 = SKTexture(imageNamed: "sloth3")
        let slothTexture4 = SKTexture(imageNamed: "sloth4")
        noAccelerationTexture = SKTexture(imageNamed: "slothsprite_nofire")
        
        sprite = SKSpriteNode(texture: noAccelerationTexture)
        
        let movingTextures = [slothTexture1, slothTexture2, slothTexture3, slothTexture4]
        for e in movingTextures {
            e.filteringMode = .Nearest
        }
        noAccelerationTexture.filteringMode = .Nearest
        
        
        
        let movingAnimation = SKAction.animateWithTextures(movingTextures, timePerFrame: 0.1)
        accelerationAnimation = SKAction.repeatActionForever(movingAnimation)
        
        
        
        sprite.setScale(2.0)
        sprite.position = CGPoint(x: 0.2 * size.width, y: 0.7 * size.height)
        
        
        sprite.zRotation = 1
        
        
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.height / 2)
        sprite.physicsBody?.dynamic = false
        sprite.physicsBody?.allowsRotation = true
        sprite.physicsBody?.mass = 1
        
        
        
        // Add masks (collision, contact, category)
        
        
        
        
    }
    
    
    //
    //    func changeAngularAccelerationTo(accel: CGFloat) {
    //        angularAccelerationScalar = accel
    //    }
    //
    //    func changeAccelerationTo(accel: CGFloat) {
    //        accelerationScalar = accel
    //    }
    //
    func stopAccelerating() {
        accelerating = false
        sprite.removeActionForKey("fire")
        sprite.texture = noAccelerationTexture
        
    }
    func accelerate() {
        accelerating = true
        sprite.runAction(accelerationAnimation, withKey: "fire")
    }
    
    func rotateTo(rot: CGFloat) {
        sprite.zRotation = rot
    }
    
    
    func accelerationVector() -> CGVector {
        let x = cos(sprite.zRotation) * accelerationForce
        let y = sin(sprite.zRotation) * accelerationForce
        
        return CGVectorMake(x, y)
    }
    
    func velocityVector() -> CGVector {
        let x = cos(sprite.zRotation) * velocityScalar
        let y = sin(sprite.zRotation) * velocityScalar
        return CGVectorMake(x, y)
    }
    
    func update(time: CFTimeInterval) {
        
        var accv = CGVectorMake(0, 0)
        if (accelerating) {
            accv = accelerationVector() * CGFloat(time)
        }
        
        let g = CGVectorMake(0, -(gravity * CGFloat(time)))
        var resultant = velocity + accv
        
        if (resultant.length() > speedLimit) {
            resultant = (resultant.normalized() * speedLimit)
        }
        
        velocity = resultant + g
        
        
        
        velocity.dx -= airResistance * velocity.dx * CGFloat(time)
        velocity.dy -= airResistance * velocity.dy * CGFloat(time)
        
        
        sprite.position.y += velocity.dy * CGFloat(time)
    
    }
    
    
}