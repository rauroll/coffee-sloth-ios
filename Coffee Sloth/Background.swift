//
//  Background.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 25/06/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit

class Background: SKNode {
    let farBgSprites = SKNode()
    let midBgSprites = SKNode()
    let floorBgSprites = SKNode()
    
    
    let farTexture: SKTexture! = SKTexture(imageNamed: "bg-far")
    let midTexture: SKTexture! = SKTexture(imageNamed: "bg-mid")
    let floorTexture: SKTexture! = SKTexture(imageNamed: "floor")
    
    let textures: [SKTexture]!
    let backgroundSprites: [SKSpriteNode]!

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init() {
    
        textures = [farTexture, midTexture, floorTexture]
        
        
        
        
        for e in textures {
            e.filteringMode = .nearest
            
        }
        
        backgroundSprites = textures.map { SKSpriteNode(texture: $0)}
        
        
        super.init()

        
        initBackgroundLevelWith(farBgSprites, tex:farTexture, depth:-40.0)
        initBackgroundLevelWith(midBgSprites, tex:midTexture, depth:-20.0)
        initBackgroundLevelWith(floorBgSprites, tex:floorTexture, depth:0.0)
        
        floorBgSprites.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: screenBounds.width, height: 1))
        floorBgSprites.physicsBody!.isDynamic = false
        
        floorBgSprites.physicsBody!.categoryBitMask = worldCategory
        floorBgSprites.physicsBody!.collisionBitMask = slothCategory
        floorBgSprites.physicsBody!.contactTestBitMask = slothCategory
        
        // These magic numbers prevent the screen bounds from having seams with no physics body edge that blocks
        // the sloth from escaping out of bounds.
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: -5, y: -50, width: screenBounds.width + 10, height: screenBounds.height + 50))
        self.physicsBody!.isDynamic = false
        self.physicsBody!.categoryBitMask = boundsCategory
        self.physicsBody!.collisionBitMask = slothCategory
        self.physicsBody!.contactTestBitMask = slothCategory
        
        
        self.addChild(farBgSprites)
        self.addChild(midBgSprites)
        self.addChild(floorBgSprites)

        
        
    }
    
    func initBackgroundLevelWith(_ node: SKNode, tex: SKTexture, depth: CGFloat) {
        for i in 0 ..< Int(2.0 + UIScreen.main.bounds.width / (tex.size().width)) + 1 {
            let sprite = SKSpriteNode(texture: tex)
            sprite.setScale(2.0)
            sprite.zPosition = depth
            sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: sprite.size.height / 2)
            node.addChild(sprite)
        }
    }
    
    
    // PERFORMANCE ISSUES HERE, GET BACK TO THIS!
    
    func addNewBackgroundSpritesTo(_ node: SKNode) {
        let first = node.children.first!
        let last = node.children.last!
        let spriteWidth = first.frame.width
        if first.position.x < spriteWidth * -1.5 {
            node.children.first?.removeFromParent()
            first.position.x = node.children.last!.position.x + spriteWidth
            node.addChild(first)
        } else if last.position.x > UIScreen.main.bounds.width + spriteWidth * 1.5 {
            node.children.last?.removeFromParent()
            last.position.x = node.children.first!.position.x - spriteWidth
            node.insertChild(last, at: 0)
            
        }
        
    }
    
    func update(_ time: CFTimeInterval, slothSpeedX: CGFloat) {
        var depth: CGFloat = 0.125
        
        
        
        
        for sprite in children[0].children {
            sprite.position.x -= slothSpeedX * depth * CGFloat(time)
        }
        
        depth = 0.3
        for sprite in children[1].children {
            sprite.position.x -= slothSpeedX * depth * CGFloat(time)
        }
        depth = 1
        
        for sprite in children[2].children {
            sprite.position.x -= slothSpeedX * depth * CGFloat(time)
        }

        
        for child in children {
            addNewBackgroundSpritesTo(child)
        }
        
        
    }
    
}
