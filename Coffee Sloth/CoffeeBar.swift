//
//  CoffeeBar.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 22/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit


class CoffeeBar: SKCropNode {
    
    let lowColor = UIColor.red
    let highColor = UIColor.green
    
    var mask: SKSpriteNode!
    var background: SKSpriteNode!
    
    
    override init() {
        mask = SKSpriteNode(color: highColor, size: CGSize(width: screenBounds.width / 3, height: 20))
        background = SKSpriteNode(color: UIColor.white, size: CGSize(width: screenBounds.width / 3, height: 20))
        background.zPosition = 1
        mask.zPosition = 2
        
        mask.anchorPoint = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 0)
        
        mask.alpha = 0.8
        background.alpha = 0.7
        
        
        
        super.init()
        
        self.position = CGPoint(x: screenBounds.width/2 - background.size.width / 2, y: screenBounds.height - background.size.height * 2)
        
        self.addChild(background)
        self.addChild(mask)

        
    }
    
    func setProgress(_ p: CGFloat) {
        let value = min(1, max(0, p)) //The value cannot be higher than 1 or lower than 0
        self.mask.xScale = value
    }
    
    func update(_ slothCoffeeLevel: CGFloat) {
        let full: CGFloat = 100
        let p = slothCoffeeLevel / full
        
        setProgress(p)
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
