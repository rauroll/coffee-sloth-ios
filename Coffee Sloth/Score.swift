//
//  Score.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 23/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit


class Score: SKLabelNode {
    
    var score: CGFloat = 0
    var distance: CGFloat = 0
    
    
    override init() {
        super.init()
        
        self.text = "\(score)"
        self.fontSize = 30
        self.fontName = "AvenirNext-Heavy"
        self.fontColor = UIColor.whiteColor()
        self.position = CGPointMake(screenBounds.width * 0.8 , 20)
        
        
    }
    
    func update(time: CFTimeInterval, velx: CGFloat) {
        
        // The coefficient controls the pace at which the player gains points by
        // moving forward in the game.
        
        distance += (velx * CGFloat(time) * 0.01)
        score = max(score, distance)
        self.text = String(format: "%.0f", score)
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}