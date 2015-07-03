//
//  GameScene.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 25/06/15.
//  Copyright (c) 2015 Ollis codes. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var background: Background!
    var lastTime: CFTimeInterval!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0, y: 0)
        
        background = Background()
        
        self.addChild(background)
        
        
        
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        if (lastTime == nil) {
            lastTime = currentTime
            return
        }
        let deltaTime = currentTime - lastTime
        lastTime = currentTime
        background.update(deltaTime)
    }
}
