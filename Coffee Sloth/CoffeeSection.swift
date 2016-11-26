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
        let coffeeTexture = SKTexture(imageNamed: "wine")
        super.init(texture: coffeeTexture, color: UIColor.clear, size: coffeeTexture.size())
//        self.texture = texture
        self.setScale(0.5)
        
        physicsBody = SKPhysicsBody(circleOfRadius: coffeeTexture.size().width/2, center: CGPoint(x: coffeeTexture.size().width/2, y: coffeeTexture.size().height/2))
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = coffeeCategory
        physicsBody?.collisionBitMask = slothCategory
        physicsBody?.contactTestBitMask = slothCategory
        
        
    }
    
    func positionInSection(_ sectionWidth: CGFloat) {
        position.x = (sectionWidth - self.size.width * 2) * randomCoefficient() + self.size.width
        position.y = (screenBounds.height - self.size.height * 2) * randomCoefficient() + self.size.height
        //position.y = screenBounds.height / 2
        print("Position : \(position)")
    }
    
    func positionInAlignment(_ sectionWidth: CGFloat) {
        position.x = (sectionWidth - self.size.width * 2) / 2 + self.size.width
        position.y = screenBounds.height / 2 + sin(SectionManager.coffeeStep) * (screenBounds.height/2 - self.size.height * 2) + self.size.height
    }
    
}

class CoffeeSection: Section {
    
    var coffee: Coffee!
    
    
    override init() {
        super.init()
        
        
        coffee = Coffee()
        self.weight = 400
        
        
        self.width = 70
        

        
        
        
        addChild(coffee)
        
        
    }
    
    func positionCoffeeInAlignment() {
        coffee.positionInAlignment(width)
    }
    
    override func enqueued() {
        coffee.positionInSection(width)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
