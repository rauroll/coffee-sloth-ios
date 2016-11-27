//
//  GameScene.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 25/06/15.
//  Copyright (c) 2015 Ollis codes. All rights reserved.
//

import SpriteKit


let screenBounds = UIScreen.main.bounds



let airResistance: CGFloat = 0.3
let gravity: CGFloat = 2000
let magneticForceLimit: CGFloat = 100
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
    var god: God!
    var overlay: Overlay!
    
    
    var gameOver: Bool
    
    var sectionManager: SectionManager!
    var magnetometer: BLMagnetometer!
    
    var audioPlayer: AudioPlayer!
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        gameOver = false
        
        super.init(size: size)
        
        magnetometer = BLMagnetometer()
        magnetometer.startUpdates()
        magnetometer.calibrate()
        
        
        
        anchorPoint = CGPoint(x: 0, y: 0)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        physicsWorld.contactDelegate = self
        
        background = Background()
        
        sloth = Sloth(size: size)
        god = God(size: size)
        
        overlay = Overlay()
        
        
        
        initSectionManager()
        
        AudioPlayer.setup()
//        let theme = SKAction.playSoundFileNamed("theme.mp3", waitForCompletion: true)
//        SKAction.repeatActionForever(theme)
        
        //self.addChild(sectionManager)
        self.addChild(sloth.sprite)
        self.addChild(god.sprite)
        self.addChild(background)
        self.addChild(overlay)
        
        
        
    }
    
    func initSectionManager() {
        sectionManager = SectionManager(sections: [
            //HorizontalBarSection(),
            OwlSection(sloth: sloth),
            EmptySection()
            ], sloth: sloth)
        self.addChild(sectionManager)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
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

            gameEnded()
            AudioPlayer.playDeathSound()
            
        case slothCategory | boundsCategory:

            sloth.velocity.dy = 0
            
        case slothCategory | coffeeCategory:


            let coffee = objectNode as! Coffee
            sloth.drinkCoffee(coffee)
            overlay.score.addCoffeeBonus(10)
            AudioPlayer.playCoffeeSound()
            
            
        case slothCategory | enemyCategory:

            gameEnded()
            AudioPlayer.playDeathSound()
        default:
            print("Unknown collision")
        }
        
        
    }
    
    func gameEnded() {
        gameOver = true
        overlay.gameEnded()
        
        
        
    }
    
    func undoGameOver() {
        gameOver = false
        
        
    }
    
    
    func reset() {
        self.removeAllChildren()
        undoGameOver()
        sloth = Sloth(size: self.size)
        god = God(size: self.size)
        initSectionManager()
        background = Background()
        overlay = Overlay()
        
        self.addChild(sloth.sprite)
        self.addChild(god.sprite)
        self.addChild(background)
        self.addChild(overlay)

    }
    
    
   
    override func update(_ currentTime: TimeInterval) {
        

        if (lastTime == nil || gameOver) {
            lastTime = currentTime
            return
        }
        let deltaTime = (currentTime - lastTime) * 0.8
        let magnetoReadings = (magnetometer.latestMagnetometerData() as NSArray).map{$0 as! CGFloat}
        lastTime = currentTime
        background.update(deltaTime, slothSpeedX: sloth.velocity.dx)
        checkForMagneticAcceleration(currentForce: magnetoReadings[3])
        sloth.update(deltaTime, readings: magnetoReadings)
        god.update(deltaTime)
        sectionManager.update(deltaTime)
        overlay.update(deltaTime, sloth: sloth)
        
    }
    
    func checkForMagneticAcceleration(currentForce: CGFloat) {
        currentForce > magneticForceLimit && sloth.hasCaffeineInBlood() ? handleMagneticAcceleration() : magneticAccelerationEnded()
    }
    
    func handleMagneticAcceleration() {
        if !sloth.accelerating {
            sloth.accelerate()
        }
    }
    
    func magneticAccelerationEnded() {
        if sloth.accelerating {
            sloth.stopAccelerating()
            sloth.checkBorders()
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        if (gameOver) {
            let node = atPoint(location)
            if (node.name != nil && node.name! == "NewGame") {
                reset()
            }
            return
        }
        
        else {
            
//            let owlSections = sectionManager.children.map{$0 as! Section}
//                .filter{$0.getSectionType() == "OwlSection"}
//                .map{$0 as! OwlSection}
//                .filter{$0.owl.alive}
            for child in sectionManager.children {
                let section = child as! Section
                if section.getSectionType() == "OwlSection" {
                    let owlSection = section as! OwlSection
                    let owl = owlSection.owl!
                    let actualOwlPosition = section.position + owl.position
                    let actualGodPosition = god.sprite.position
                    print("OWL POSITION: ", actualOwlPosition, ", GOD POSITION: ", actualGodPosition)
                    if fabs(actualOwlPosition.x - actualGodPosition.x) < 100 && owl.alive {
                        god.rainTerror()
                        
                        let particlePosition = CGPoint(x: actualOwlPosition.x, y: screenBounds.height / 2)
                        
                        let path = Bundle.main.path(forResource: "lightning", ofType: "sks")
                        let fireparticle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
                        
                        fireparticle.position = particlePosition
                        fireparticle.name = "lightning"
                        fireparticle.targetNode = self.scene
                        fireparticle.zPosition = 10000
                        self.addChild(fireparticle)
                        
                        fireparticle.run(
                            SKAction.sequence([
                                SKAction.wait(forDuration: 0.1),
                                SKAction.removeFromParent(),
                                ])
                        )

                        
                        owl.kill()
                    }
                }
            }
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sloth.stopAccelerating()
        sloth.checkBorders()
        
    }
}
