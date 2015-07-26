//
//  Overlay.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 22/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit


class Overlay: SKNode {
    
    var coffeeBar: CoffeeBar!
    var score: Score!
    
    
    override init() {
        super.init()
        
        reset()
        
        
    }
    
    func reset() {
        createCoffeeBar()
        createScoreNode()
        
    }
    
    func createCoffeeBar() {
        if (coffeeBar != nil) {
            coffeeBar.removeFromParent()
        }
        coffeeBar = CoffeeBar()
        
        addChild(coffeeBar)
    }
    
    func createScoreNode() {
        if (score != nil) {
            score.removeFromParent()
        }
        score = Score()
        addChild(score)
    }
    
    func update(time: CFTimeInterval, sloth: Sloth) {
        coffeeBar.update(sloth.coffeeLevel)
        score.update(time, velx: sloth.velocity.dx)
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}