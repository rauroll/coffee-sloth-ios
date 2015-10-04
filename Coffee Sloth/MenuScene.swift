//
//  MenuScene.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 26/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    
    var buttons: [SKLabelNode]!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        
        let playButton = SKLabelNode(text: "Play")
        playButton.name = "Play"
        let creditsButton = SKLabelNode(text: "Credits")
        creditsButton.name = "Credits"
        
        buttons = [playButton, creditsButton]
        let buttonHeight = size.height * 0.8 / CGFloat(buttons.count)
        
        for b in buttons {
            b.fontSize = 30
            b.fontName = "AvenirNext-Heavy"
            b.fontColor = UIColor.whiteColor()
            b.alpha = 0.9
            b.zPosition = 5
            b.position = CGPointMake(size.width / 2, (CGFloat(buttons.count) - 1 - CGFloat(buttons.indexOf(b)!)) * buttonHeight + size.height * 0.2)
            self.addChild(b)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let node = nodeAtPoint(location)
        if let n = node.name {
            switch n {
            case "Play":
                let scene = GameScene(size: self.scene!.size)
                let transition = SKTransition.fadeWithDuration(0.5)
                
                scene.scaleMode = .ResizeFill
                
                self.scene!.view!.presentScene(scene, transition: transition)
            default:
                print("Nothing implemented for this menu item yet")
            }
        }
    }
}