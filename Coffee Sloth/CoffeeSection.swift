//
//  Coffee.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 06/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit



class Coffee: SKSpriteNode {
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        let coffeeTexture = SKTexture(imageNamed: "coffee")
        super.init(texture: coffeeTexture, color: UIColor.clearColor(), size: coffeeTexture.size())
//        self.texture = texture
        
        physicsBody = SKPhysicsBody(circleOfRadius: coffeeTexture.size().width/2, center: CGPointMake(coffeeTexture.size().width/2, coffeeTexture.size().height/2))
        physicsBody?.dynamic = true
        physicsBody?.categoryBitMask = coffeeCategory
        physicsBody?.collisionBitMask = slothCategory
        physicsBody?.contactTestBitMask = slothCategory
        
        
    }
    
    func positionInSection(sectionWidth: CGFloat) {
        position.x = (sectionWidth - self.size.width * 2) * randomCoefficient() + self.size.width
        //position.y = (screenBounds.height - self.size.height * 2) * randomCoefficient() + self.size.height
        position.y = screenBounds.height / 2
    }
    
}

class CoffeeSection: Section {
    
    var coffee: Coffee!
    
    
    override init() {
        super.init()
        
        
        coffee = Coffee()
        self.weight = 4
        
        
        self.width = 100
        
        self.setScale(0.7)
        
        
        
        addChild(coffee)
        
        
    }
    
    override func enqueued() {
        coffee.positionInSection(width)
        //print("Enqueued a coffee section! Coffee at: \(coffee.position)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}