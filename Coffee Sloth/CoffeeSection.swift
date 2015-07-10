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
        self.texture = texture
        
        
    }
    
    func positionInSection(sectionWidth: CGFloat) {
        position.x = sectionWidth * randomCoefficient()
        position.y = screenBounds.height * randomCoefficient()
    }
    
}

class CoffeeSection: Section {
    
    var coffee: Coffee!
    
    
    override init() {
        super.init()
        
        
        coffee = Coffee()
        self.weight = 6
        
        
        self.width = 100
        
        
        
        addChild(coffee)
        
        
    }
    
    override func enqueued() {
        coffee.positionInSection(width)
        print("Enqueued a coffee section! Coffee at: \(coffee.position)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}