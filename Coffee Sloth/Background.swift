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
            e.filteringMode = .Nearest
            
        }
        
        backgroundSprites = textures.map { SKSpriteNode(texture: $0)}
        
        
        super.init()

        
        initBackgroundLevelWith(farBgSprites, tex:farTexture, depth:-40.0)
        initBackgroundLevelWith(midBgSprites, tex:midTexture, depth:-20.0)
        initBackgroundLevelWith(floorBgSprites, tex:floorTexture, depth:0.0)
        

        
        
        
//        
//        for tex in textures {
//            var depth: CGFloat = -40
//            print(UIScreen.mainScreen().bounds.width)
//            for var i: CGFloat = 0; i < 2.0 + UIScreen.mainScreen().bounds.width / (tex.size().width * 2.0); ++i {
//                let sprite = SKSpriteNode(texture: tex)
//                sprite.setScale(2.0)
//                sprite.zPosition = depth
//                print(i*sprite.size.width)
//                sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2)
//                let moveSpriteAction = SKAction(named: <#T##String#>, duration: <#T##NSTimeInterval#>)
//                self.addChild(sprite)
//            }
//            depth += 20
//        }
        
        self.addChild(farBgSprites)
        self.addChild(midBgSprites)
        self.addChild(floorBgSprites)
        
        print(self.children)

        
        
        
        

        
        
    }
    
    func initBackgroundLevelWith(node: SKNode, tex: SKTexture, depth: CGFloat) {
        for var i: CGFloat = 0; i < 2.0 + UIScreen.mainScreen().bounds.width / (tex.size().width * 2.0); ++i {
            let sprite = SKSpriteNode(texture: tex)
            sprite.setScale(2.0)
            sprite.zPosition = depth
            print(i*sprite.size.width)
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2)
            node.addChild(sprite)
        }
    }
    
    
    // PERFORMANCE ISSUES HERE, GET BACK TO THIS!
    
    func addNewBackgroundSpritesTo(node: SKNode) {
        let first = node.children.first!
        let last = node.children.last!
        let spriteWidth = first.frame.width
        if first.position.x < spriteWidth * -1.5 {
            node.children.first?.removeFromParent()
            first.position.x = node.children.last!.position.x + spriteWidth
            node.addChild(first)
        } else if last.position.x > UIScreen.mainScreen().bounds.width + spriteWidth * 1.5 {
            node.children.last?.removeFromParent()
            last.position.x = node.children.first!.position.x - spriteWidth
            node.insertChild(last, atIndex: 0)
            
        }
        
    }
    
    func update(time: CFTimeInterval, coeff: CGFloat) {
        var depth = CGFloat(1.5)
        let pixelsMoved = CGFloat(25) * CGFloat(time)
        for child in self.children {
            
            for sprite in child.children {
                sprite.position.x -= pixelsMoved * coeff * depth
            }
            depth *= 1.5
            addNewBackgroundSpritesTo(child)
            print(pixelsMoved)
        }
        
        
    }
    
    

    
    
    
}