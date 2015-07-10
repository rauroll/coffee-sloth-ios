//
//  SectionManager.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 05/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit


class SectionManager: SKNode {
    
    var sections: [Section]!
    var maxWeight: CGFloat!
    var sloth: Sloth
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(sections: [Section], sloth: Sloth) {
        self.sloth = sloth
        
        self.sections = sections.sort{$0.weight > $1.weight}
        maxWeight = self.sections.first!.weight
        
        
        
        super.init()
        
    }
    
    func update(time: CFTimeInterval) {
        
        let dx = sloth.velocity.dx * CGFloat(time)
        
        if(children.isEmpty) {
            enqueue(EmptySection(width: screenBounds.width * 0.5));
        } else {
            for (var i = 0; i < children.count; i++) {
                let section = children[i] as! Section;
                section.position.x -= dx
                section.update()
                
                // if the last section in the queue is visible or the queue is empty, add a new section
                if((i == children.count - 1 && section.isVisible()) || children.isEmpty) {
                    increaseQueue()
                    break
                }
                
                // if this section is further away than the viewport width remove it
                if (section.position.x < -screenBounds.width) {
                    dequeue(section)
                    i--
                }
                
                // check if player is inside a section
                let p = sloth.sprite.position;
                if (!section.playerIsInside && p.x > section.position.x && p.x < section.position.x + section.width) {
                    section.playerIsInside = true
                    section.playerEntered()
                } else if (section.playerIsInside && (p.x > section.position.x + section.width || p.x < section.position.x)) {
                    section.playerIsInside = false
                    section.playerExited()
                }
            }
        }
    }
    
    func increaseQueue() {
        var offset: CGFloat = 0
        
        if (children.count > 0) {
            let lastSection = children.last! as! Section
            offset = lastSection.position.x + lastSection.width
        }
        
        //let r = CGFloat(arc4random()) / CGFloat(UInt32.max) * maxWeight
        let randomSection: Section! = pickRandomSection()
//        var c: CGFloat = 0
//        for (var i = 0; i < sections.count; i++) {
//            let s = sections[i]
//            c += s.weight
//            if (r < c) {
//                randomSection = s.copy() as! Section
//                break
//            }
//        }
        randomSection.position.x = offset
        enqueue(randomSection)
    }
    
    func pickRandomSection() -> Section {
        return zip(sections, sections.map{$0.weight * randomCoefficient()}).sort{$0.1 > $1.1}.first!.0.copy() as! Section
    }
    
    func enqueue(section: Section) {
        section.enqueued()
        self.addChild(section)
    }
    
    func dequeue(section: Section) {
        section.dequeued()
        section.removeFromParent()
    }
    
    func reset(section: Section) {
        // TODO
    }
    
    func canMoveBackwards() {
        // TODO
    }
    
    
    
}

