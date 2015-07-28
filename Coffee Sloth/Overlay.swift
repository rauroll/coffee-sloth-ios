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
        newGameLabel = SKLabelNode(text: "Play again!")
        newGameLabel.name = "NewGame"
        newGameLabel.fontName = "AvenirNext-Heavy"
        newGameLabel.fontSize = 50
        newGameLabel.fontColor = UIColor.whiteColor()
        newGameLabel.position = CGPointMake(screenBounds.width / 2, screenBounds.height * 2)
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
    
    func update(time: CFTimeInterval, sloth: Sloth) {
        coffeeBar.update(sloth.coffeeLevel)
        score.update(time, velx: sloth.velocity.dx)
    }
    
    func gameEnded() {
        let middlePoint = CGPointMake(screenBounds.width / 2, screenBounds.height / 2)
        let belowMiddlePoint = CGPointMake(middlePoint.x, screenBounds.height * 0.3)
        
        let moveToMiddle = SKAction.moveTo(middlePoint, duration: 0.3)
        moveToMiddle.timingMode = .EaseOut
        let moveBelowScore = SKAction.moveTo(belowMiddlePoint, duration: 0.5)
        moveBelowScore.timingMode = .EaseOut
        
        let grayMask = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(screenBounds.width * 2, screenBounds.height * 2))
        grayMask.zPosition = 10
        grayMask.alpha = 0.0
        self.addChild(grayMask)
        let fadeMaskIn = SKAction.fadeAlphaTo(0.5, duration: 0.8)
        fadeMaskIn.timingMode = .EaseOut
        

        
        grayMask.runAction(fadeMaskIn)
        score.runAction(moveToMiddle, completion: {self.newGameLabel.runAction(moveBelowScore)})
        
        
        
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}