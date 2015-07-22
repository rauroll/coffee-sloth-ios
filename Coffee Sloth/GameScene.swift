//
//  GameScene.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 25/06/15.
//  Copyright (c) 2015 Ollis codes. All rights reserved.
//

import SpriteKit


let screenBounds = UIScreen.mainScreen().bounds



let airResistance: CGFloat = 0.3
let gravity: CGFloat = 500
//900

let slothCategory: UInt32 = 1 << 0
let worldCategory: UInt32 = 1 << 1
let boundsCategory: UInt32 = 1 << 2
let coffeeCategory: UInt32 = 1 << 3
let enemyCategory: UInt32 = 1 << 4


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var background: Background!
    var lastTime: CFTimeInterval!
    var speedCoefficient: CGFloat = 3
    var sloth: Sloth!
    var gameOver: Bool
    
    var sectionManager: SectionManager!
    
    var audioPlayer: AudioPlayer!
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        gameOver = false
        
        super.init(size: size)
        
    
        
        anchorPoint = CGPoint(x: 0, y: 0)
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        physicsWorld.contactDelegate = self
        
        background = Background()
        
        sloth = Sloth(size: size)
        
        
        
        initSectionManager()

        
        AudioPlayer.setup()
//        let theme = SKAction.playSoundFileNamed("theme.mp3", waitForCompletion: true)
//        SKAction.repeatActionForever(theme)
        
        //self.addChild(sectionManager)
        self.addChild(sloth.sprite)
        self.addChild(background)
        
        
        
    }
    
    func initSectionManager() {
        sectionManager = SectionManager(sections: [
            EmptySection(width: 200),
            CoffeeSection(),
            HorizontalBarSection(),
            OwlSection(sloth: sloth)
            ], sloth: sloth)
        self.addChild(sectionManager)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var playerNode, objectNode: SKNode!
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            playerNode = contact.bodyA.node
            objectNode = contact.bodyB.node
        } else {
            playerNode = contact.bodyB.node
            objectNode = contact.bodyA.node
        }
        
        let collision = playerNode!.physicsBody!.categoryBitMask | objectNode!.physicsBody!.categoryBitMask
        
        switch collision {
        case slothCategory | worldCategory:
            print("Sloth collided with an obstacle or the floor")
            gameOver = true
            AudioPlayer.playDeathSound()
            
        case slothCategory | boundsCategory:
            print("Collided to the bounds!")
            sloth.velocity.dy = 0
            
        case slothCategory | coffeeCategory:
            print("Sloth collided with a coffee")
            print("Is this a problem to the compiler")
            let coffee = objectNode as! Coffee
            sloth.drinkCoffee(coffee)
            AudioPlayer.playCoffeeSound()
            
            
        case slothCategory | enemyCategory:
            print("Sloth collided with an enemy")
            gameOver = true
            AudioPlayer.playDeathSound()
        default:
            print("Unknown collision")
        }
        
        
    }
    
    
    func reset() {
        self.removeAllChildren()
        gameOver = false
        sloth = Sloth(size: self.size)
        initSectionManager()
        background = Background()
        
        self.addChild(sloth.sprite)
        self.addChild(background)

    }
    
    
   
    override func update(currentTime: CFTimeInterval) {
        

        if (lastTime == nil || gameOver) {
            lastTime = currentTime
            return
        }
        let deltaTime = (currentTime - lastTime)
        lastTime = currentTime
        background.update(deltaTime, slothSpeedX: sloth.velocity.dx)
        sloth.update(deltaTime)
        sectionManager.update(deltaTime)
        
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (gameOver) {
            reset()
            return
        }
        let location = touches.first!.locationInNode(self)
        let newRot = angleBetweenPoints(sloth.sprite.position, second: location)
        sloth.rotateTo(newRot)
        sloth.accelerate()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        sloth.stopAccelerating()
        sloth.checkBorders()
        
    }
}
