//
//  GameScene.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 25/06/15.
//  Copyright (c) 2015 Ollis codes. All rights reserved.
//

import SpriteKit


let airResistance: CGFloat = 0.3
let gravity: CGFloat = 250


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background: Background!
    var lastTime: CFTimeInterval!
    var speedCoefficient: CGFloat = 3
    
    var slothCategory: UInt32 = 1 << 0
    var worldCategory: UInt32 = 1 << 1
    
    var sloth: Sloth!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0, y: 0)
        
        //self.physicsWorld.gravity = CGVectorMake(0, -1)
        
        background = Background()
        sloth = Sloth(size: size)
        
        self.addChild(sloth.sprite)
        self.addChild(background)
        
        
        
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        if (lastTime == nil) {
            lastTime = currentTime
            return
        }
        let deltaTime = (currentTime - lastTime)
        lastTime = currentTime
        background.update(deltaTime, slothSpeedX: sloth.velocity.dx)
        sloth.update(deltaTime)
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let newRot = angleBetweenPoints(sloth.sprite.position, second: location)
        sloth.rotateTo(newRot)
        sloth.accelerate()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        sloth.stopAccelerating()
    }
}
