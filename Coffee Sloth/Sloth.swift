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
    
    let accelerationForce: CGFloat = 3000
    // 4000
    
    var velocity = CGVector(dx: 0, dy: 0)
    
    var angularAcceleration: CGFloat = 1.0
    var angularVelocity: CGFloat = 0

    
    let maxCoffeeLevel: CGFloat = 100
    var coffeeLevel: CGFloat = 100
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize) {
        
        coffeeLevel = 100
        
        let slothTexture1 = SKTexture(imageNamed: "babyjesus1")
        let slothTexture2 = SKTexture(imageNamed: "babyjesus2")
        let slothTexture3 = SKTexture(imageNamed: "babyjesus3")
        //let slothTexture4 = SKTexture(imageNamed: "babyjesus2")
        
        noAccelerationTexture = SKTexture(imageNamed: "babyjesus1")
        
        sprite = SKSpriteNode(texture: noAccelerationTexture)
        
        let movingTextures = [slothTexture1, slothTexture2, slothTexture3/*, slothTexture4*/]
        for e in movingTextures {
            e.filteringMode = .nearest
        }
        noAccelerationTexture.filteringMode = .nearest
        
        let movingAnimation = SKAction.animate(with: movingTextures, timePerFrame: 0.1)
        accelerationAnimation = SKAction.repeatForever(movingAnimation)
    
        sprite.setScale(1.6)
        sprite.position = CGPoint(x: 0.2 * size.width, y: 0.7 * size.height)
        
        sprite.zPosition = 1
        
        sprite.zRotation = 1
        
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.height / 2)
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.allowsRotation = true
        sprite.physicsBody?.mass = 0
        
        sprite.physicsBody?.categoryBitMask = slothCategory
        sprite.physicsBody?.collisionBitMask = worldCategory | boundsCategory | coffeeCategory | enemyCategory
        sprite.physicsBody?.contactTestBitMask = worldCategory | boundsCategory | coffeeCategory | enemyCategory
        
    
    }
    
    func reset() {
        coffeeLevel = 100
    }
    

    func drinkCoffee(_ coffee: Coffee) {
        coffeeLevel = min(maxCoffeeLevel, coffeeLevel + 10)
        coffee.removeFromParent()
    }
    
    func reduceCoffeeLevel(_ time: CFTimeInterval) {
        coffeeLevel = max(0, coffeeLevel - 10 * CGFloat(time))
    }
    
    func hasCaffeineInBlood() -> Bool {
        return (coffeeLevel > 0)
    }
    
    func stopAccelerating() {
        accelerating = false
        print("Stopping acceleration animation")
        sprite.removeAction(forKey: "fire")
        sprite.texture = noAccelerationTexture
        
    }
    func accelerate() {
        accelerating = true
        print("Running acceleration animation")
        sprite.run(accelerationAnimation, withKey: "fire")
    }
    
    func updateRotation() {
        if (!isAtUpperBorder()) {
            sprite.zRotation = clamp( -1, max: 0.5, value: velocity.dy * ( velocity.dy < 0 ? 0.003 : 0.001 ) )
        }
    }
    
    // Not in use with current sloth control implementation
    func rotateTo(_ rot: CGFloat) {
        let rotationAction = SKAction.rotate(toAngle: rot, duration: 0.15)
        sprite.run(rotationAction)
    }
    
    
    func accelerationVector() -> CGVector {
        let x = cos(sprite.zRotation) * accelerationForce
        let y = sin(sprite.zRotation) * accelerationForce
        return CGVector(dx: x, dy: y)
    }
    
    func magnetoAccelerationVector(force: CGFloat) -> CGVector {
        let forceCoefficient: CGFloat = 5
        let scaledForce = forceCoefficient * force
        let x = cos(sprite.zRotation) * scaledForce
        let y = sin(sprite.zRotation) * scaledForce
        return CGVector(dx: x, dy: y)
    }
    
    func isUsingMagneticAcceleration(force: CGFloat) -> Bool {
        return force > 300
    }
    
    
    func isAtUpperBorder() -> Bool {
        return sprite.position.y >= screenBounds.height - sprite.size.height/2 - 1
    }
    
    func isAtLeftBorder() -> Bool {
        return sprite.position.x < 3
    }
    
    func checkBorders() {
        if (isAtUpperBorder()) {
            velocity.dy = min(velocity.dy, 0)
        }
        if (isAtLeftBorder()) {
            velocity.dx = max(velocity.dx, 0)
        }
    }
    
    func update(_ time: CFTimeInterval, readings: [CGFloat]) {
        
        reduceCoffeeLevel(time)
        
        var accv = CGVector(dx: 0, dy: 0)
//        if (accelerating) {
//            if (!isAtUpperBorder()) {
//                sprite.zRotation = max(sprite.zRotation + angularAcceleration, 1)
//            }
//            accv = accelerationVector() * CGFloat(time)
//        }
        
        if accelerating {
            if (!isAtUpperBorder()) {
                sprite.zRotation = max(sprite.zRotation + angularAcceleration, 1)
            }
            accv = magnetoAccelerationVector(force: readings[3]) * CGFloat(time)
            
        }
        
        updateRotation()
        
        
        let g = CGVector(dx: 0, dy: -(gravity * CGFloat(time)))
        var resultant = velocity + accv
        
        if (resultant.length() > speedLimit) {
            resultant = (resultant.normalized() * speedLimit)
        }
        
        velocity = resultant + g
        
        velocity.dx -= airResistance * velocity.dx * CGFloat(time)
        velocity.dy -= airResistance * velocity.dy * CGFloat(time)
        
        //check borders before moving the sloth
        let verticalMovement = velocity.dy * CGFloat(time)
        
        if (sprite.position.y + verticalMovement <= screenBounds.size.height) {
            sprite.position.y += velocity.dy * CGFloat(time)
        }
    
    }
    
    
}
