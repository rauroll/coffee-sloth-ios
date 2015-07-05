//
//  Coffee.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 05/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit

class Coffee: SKSpriteNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(position: CGPoint) {
        let texture = SKTexture(imageNamed: "coffee")
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        
        self.position = position
    }
}