//
//  God.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 26/11/2016.
//  Copyright © 2016 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit


class God {

    // GRAPHICS
    
    var sprite: SKSpriteNode!
    var speechBubble: SpeechBubble?
    
    // MOVEMENTS
    
    var movementStepper: CGFloat = 0
    let movementRadius: CGPoint
    var startingPosition: CGPoint
    
    var attackAnimation: SKAction!
    
    var speechCounter: CGFloat = 4.5
    
    let quotes = [
        "C'mon, Baby Jesus!",
        "Baby Jesus you can do it!",
        "Keep going Baby Jesus!",
        "YOLO Baby Jesus!",
        "In Baby Jesus we trust"
    ]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(size: CGSize) {
        
        let godTexture = SKTexture(imageNamed: "god")
        godTexture.filteringMode = .nearest
        
        let attackTexture1 = SKTexture(imageNamed: "godslaying1")
        let attackTexture2 = SKTexture(imageNamed: "godslaying2")
        let attackTexture3 = SKTexture(imageNamed: "godslaying3")
        
        let attackTextures = [attackTexture1, attackTexture2, attackTexture3, attackTexture2, godTexture]
        attackAnimation = SKAction.animate(with: attackTextures, timePerFrame: 0.1)
        
        sprite = SKSpriteNode(texture: godTexture)
        
        sprite.setScale(1.6)
        movementRadius = CGPoint(x: 75, y: 10)
        startingPosition = CGPoint(x: 0.8 * size.width, y: 0.8 * size.height)
        sprite.position = startingPosition
        
        sprite.zPosition = -3
        
    }
    
    func pickRandomQuote() -> String {
        let index = Int(arc4random_uniform(UInt32(quotes.count)))
        return quotes[index]
    }
    
    func addSpeechBubble() {
        speechBubble = SpeechBubble(text: pickRandomQuote())
        sprite.addChild(speechBubble!)
    }
    
    func speak() {
        let myFunction = SKAction.run({() in self.addSpeechBubble()})
        let duration = SKAction.wait(forDuration: 2)
        let remove = SKAction.run({() in self.speechBubble!.removeFromParent()})
        self.sprite.run(SKAction.sequence([myFunction, duration, remove]))
    }
    
    func rainTerror() {
        sprite.run(attackAnimation)
    }
    
    func update(_ time: CFTimeInterval) {
        sprite.position.x = startingPosition.x + cos(movementStepper) * movementRadius.x
        sprite.position.y = startingPosition.y + sin(movementStepper) * movementRadius.y
        
        movementStepper += CGFloat(3) * CGFloat(time)
        if (movementStepper >= CGFloat(2 * M_PI)) {
            movementStepper = movementStepper - CGFloat(2 * M_PI)
        }
        
        speechCounter += CGFloat(time)
        if speechCounter > 5 {
            speak()
            speechCounter = 0
        }
        
    }
    
    
    
}
