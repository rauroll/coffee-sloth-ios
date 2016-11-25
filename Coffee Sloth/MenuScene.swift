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
            b.fontColor = UIColor.white
            b.alpha = 0.9
            b.zPosition = 5
            b.position = CGPoint(x: size.width / 2, y: (CGFloat(buttons.count) - 1 - CGFloat(buttons.index(of: b)!)) * buttonHeight + size.height * 0.2)
            self.addChild(b)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        let node = atPoint(location)
        if let n = node.name {
            switch n {
            case "Play":
                let scene = GameScene(size: self.scene!.size)
                let transition = SKTransition.fade(withDuration: 0.5)
                
                scene.scaleMode = .resizeFill
                
                self.scene!.view!.presentScene(scene, transition: transition)
            default:
                print("Nothing implemented for this menu item yet")
            }
        }
    }
}
