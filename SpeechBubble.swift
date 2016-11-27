//
//  SpeechBubble.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 26/11/2016.
//  Copyright © 2016 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit

class SpeechBubble: SKNode {
    
    var speechLabel: SKLabelNode!
    var bubbleNode: SKSpriteNode!
    
    init(text: String) {
        
        super.init()
        
        let bubbleTexture = SKTexture(imageNamed: "bubble")
        
        speechLabel = SKLabelNode(text: text)
        speechLabel.setScale(0.7)
        speechLabel.fontColor = UIColor.black
        speechLabel.position.y = -15
        speechLabel.fontSize = 30
        
        bubbleNode = SKSpriteNode(texture: bubbleTexture)
        bubbleNode.setScale(0.65)
        
        bubbleNode.zPosition = 1
        speechLabel.zPosition = 2
        
        self.position = CGPoint(x: -100, y: -10)
        
        bubbleNode.addChild(speechLabel)
        addChild(bubbleNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
