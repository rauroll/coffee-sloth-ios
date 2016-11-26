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
    
    var newGameLabel: SKLabelNode!
    
    
    override init() {
        super.init()
        
        reset()
        
        
    }
    
    func reset() {
        createCoffeeBar()
        createScoreNode()
        createNewGameLabel()
        
    }
    
    func createCoffeeBar() {
        if (coffeeBar != nil) {
            coffeeBar.removeFromParent()
        }
        coffeeBar = CoffeeBar()
        
        coffeeBar.zPosition = 0
        addChild(coffeeBar)
    }
    
    func createNewGameLabel() {
        newGameLabel = SKLabelNode(text: "Born again?")
        newGameLabel.name = "NewGame"
        newGameLabel.fontName = "Courier"
        newGameLabel.fontSize = 50
        newGameLabel.fontColor = UIColor.white
        newGameLabel.position = CGPoint(x: screenBounds.width / 2, y: screenBounds.height * 2)
        newGameLabel.zPosition = 100
        self.addChild(newGameLabel)

    }
    
    func createScoreNode() {
        if (score != nil) {
            score.removeFromParent()
        }
        
        score = Score()
        score.zPosition = 100
        addChild(score)
    }
    
    func update(_ time: CFTimeInterval, sloth: Sloth) {
        coffeeBar.update(sloth.coffeeLevel)
        score.update(time, velx: sloth.velocity.dx)
    }
    
    func gameEnded() {
        let middlePoint = CGPoint(x: screenBounds.width / 2, y: screenBounds.height / 2)
        let belowMiddlePoint = CGPoint(x: middlePoint.x, y: screenBounds.height * 0.3)
        
        let moveToMiddle = SKAction.move(to: middlePoint, duration: 0.3)
        moveToMiddle.timingMode = .easeOut
        let moveBelowScore = SKAction.move(to: belowMiddlePoint, duration: 0.5)
        moveBelowScore.timingMode = .easeOut
        
        let grayMask = SKSpriteNode(color: UIColor.black, size: CGSize(width: screenBounds.width * 2, height: screenBounds.height * 2))
        grayMask.zPosition = 10
        grayMask.alpha = 0.0
        self.addChild(grayMask)
        let fadeMaskIn = SKAction.fadeAlpha(to: 0.5, duration: 0.8)
        fadeMaskIn.timingMode = .easeOut
        

        
        grayMask.run(fadeMaskIn)
        score.run(moveToMiddle, completion: {self.newGameLabel.run(moveBelowScore)})
        
        
        
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
