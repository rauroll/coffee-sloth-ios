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
    
    var sprite = SKSpriteNode(imageNamed: "asset/image/sloth/slothsprite1.png")
    
    var trueVelocity = CGPoint(x: 0, y: 0)
    var acceleration = CGFloat(0)
    let rotationStep = CGFloat(8)
    
    init(size: CGSize) {
        sprite.position = CGPoint(x: 0.2 * size.width, y: 0.7 * size.height)
        acceleration = 0
        trueVelocity = CGPoint(x: 0, y: 0)
        sprite.zRotation = 0
        
    }
    
    
}