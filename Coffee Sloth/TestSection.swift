//
//  TestSection.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 10/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit

class TestSection: Section {
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat) {
        super.init()
        
        
        self.width = width
        
    }
    
    override init() {
        super.init()
        
        self.weight = 5
        self.width = 200.0
    }
    
    override func enqueued() {
        markTheSection()
        //print("Enqueued a test section")
    }
    
    func markTheSection() {
        removeAllChildren()
        let dot = shapeByRand(arc4random_uniform(2))
        dot.fillColor = UIColor.red
        dot.position = CGPoint(x: self.width / 2, y: UIScreen.main.bounds.height / 2.0)
        addChild(dot)
    }
    
    func shapeByRand(_ r: UInt32) -> SKShapeNode {
        var shape: SKShapeNode!
        switch r {
        case 0: shape = SKShapeNode(ellipseOf: CGSize(width: 50, height: 50)); shape.fillColor = UIColor.red
        case 1: shape = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 50, height: 50)); shape.fillColor = UIColor.blue
        default: shape = nil
        }
        return shape
    }
}
