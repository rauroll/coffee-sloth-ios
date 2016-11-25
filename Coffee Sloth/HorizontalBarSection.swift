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
    
    let maxHeight: CGFloat = screenBounds.height / 2
    let minHeight: CGFloat = screenBounds.height / 4
    
    var offset: CGFloat = 30
    
    var bar: SKShapeNode!
    
    var stepper: CGFloat = 0
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        
        super.init()
        
        width = 50
        
        
        
        
        weight = 8
        
        
        
    }
    
    override func update(_ time: CFTimeInterval) {
        
        let step = 2 * CGFloat(time)
       

        bar.position.y = sin(stepper) * (screenBounds.height - bar.frame.height * 1.5)

        stepper += step
    }
    
    override func enqueued() {
        initBar()
    }
    
    func initBar() {
        
        stepper = randomCoefficient() * CGFloat(M_PI)
        self.removeAllChildren()
        
        let barHeight = minHeight + (maxHeight-minHeight) * randomCoefficient()
        let myRect = CGRect(x: offset, y: (screenBounds.height / 2), width: width - offset, height: barHeight)
        bar = SKShapeNode(rect: myRect)
        
        bar.fillColor = UIColor.white
        bar.alpha = 0.65
        

        bar.physicsBody = SKPhysicsBody(edgeLoopFrom: myRect)
        bar.physicsBody!.isDynamic = false
        
        bar.physicsBody!.categoryBitMask = worldCategory
        bar.physicsBody!.collisionBitMask = slothCategory
        bar.physicsBody!.contactTestBitMask = slothCategory
        
        addChild(bar)
    }
}
