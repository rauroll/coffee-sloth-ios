//
//  OwlSection.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 12/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit

class HorizontalBarSection: Section {
    
    var maxHeight: CGFloat = screenBounds.height / 1.7
    var offset: CGFloat = 30
    
    var bar: SKShapeNode!
    
    var stepper: CGFloat = 0
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        
        super.init()
        
        width = 50
        
        
        
        weight = 4
        
        
        
    }
    
    override func update(time: CFTimeInterval) {
        
        let step = 3 * CGFloat(time)
       

        bar.position.y = sin(stepper) * (screenBounds.height - bar.frame.height * 1.5)

        stepper += step
    }
    
    override func enqueued() {
        initBar()
    }
    
    func initBar() {
        
        stepper = randomCoefficient() * CGFloat(M_PI)
        self.removeAllChildren()
        
        let barHeight = (maxHeight - 100) * randomCoefficient() + 100
        let myRect = CGRectMake(offset, (screenBounds.height / 2 - barHeight / 2), width - offset, barHeight)
        bar = SKShapeNode(rect: myRect)
        
        bar.fillColor = UIColor.whiteColor()
        bar.alpha = 0.65
        
        print("Initialized a bar of size \(bar.frame.size)")
        bar.physicsBody = SKPhysicsBody(edgeLoopFromRect: myRect)
        bar.physicsBody!.dynamic = false
        
        bar.physicsBody!.categoryBitMask = worldCategory
        bar.physicsBody!.collisionBitMask = slothCategory
        bar.physicsBody!.contactTestBitMask = slothCategory
        
        addChild(bar)
    }
}