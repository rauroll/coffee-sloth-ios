//
//  Section.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 06/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit



class Section: SKNode {
    
    var nodes: [SKSpriteNode]! = nil
    var playerIsInside = false
    var width: CGFloat! = nil
    var weight: CGFloat = 1
    var sectionType: String! = nil
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init() {
        
        super.init()
    }
    
    func enqueued() {
        //preconditionFailure("This method has to be overridden")
    }
    
    func dequeued() {
        //preconditionFailure("This method has to be overridden")
    }

    
    func playerEntered() {
        //preconditionFailure("This method has to be overridden")
    }

    
    func playerExited() {
        //preconditionFailure("This method has to be overridden")
    }

    
    func update(time: CFTimeInterval) {
        //preconditionFailure("This method has to be overridden")
    }

    
    func isVisible() -> Bool {
        return (position.x < UIScreen.mainScreen().bounds.width && position.x > -width)
    }

    
}