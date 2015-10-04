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
    static var coffeeStep: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    init(sections: [Section], sloth: Sloth) {
        self.sloth = sloth
        
        self.sections = sections.sort{$0.weight > $1.weight}
        maxWeight = self.sections.first!.weight
        
        
        
        
        
        super.init()
        
        // The sloth always starts in an empty section
        enqueue(EmptySection(width: screenBounds.width))
        
    }
    
    func update(time: CFTimeInterval) {

        
        let dx = sloth.velocity.dx * CGFloat(time)
        
        if(children.isEmpty) {
            enqueue(EmptySection(width: screenBounds.width * 0.5));
        } else {
            for (var i = 0; i < children.count; i++) {
                let section = children[i] as! Section;
                section.position.x -= dx
                section.update(time)
                
                // if the last section in the queue is visible or the queue is empty, add a new section
                if((i == children.count - 1 && section.isVisible()) || children.isEmpty) {
                    (randomCoefficient() < 0.85) ? increaseQueue(true) : increaseQueue(false)
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
    
    func increaseQueue(coffeeString: Bool) {
        var offset: CGFloat = 0
        
        if let lastSection: Section? = children.last as! Section? {
            
            offset = lastSection!.position.x + lastSection!.width
        }
        
        if (coffeeString) {
            let numberOfCoffees: Int = Int(randomCoefficient() * 8) + 2
            let curve = randomCoefficient() * 0.5 + 0.1

            for (var i = 0; i < numberOfCoffees; i++) {
                let coffeeSection = CoffeeSection()
                coffeeSection.position.x = offset
                offset += coffeeSection.width
                coffeeSection.positionCoffeeInAlignment()
                SectionManager.increaseCoffeeStep(curve)
                self.addChild(coffeeSection)
            }
        }
        
        let randomSection: Section! = pickRandomSection()
        randomSection.position.x = offset
        enqueue(randomSection)
        
    }
    
    static func increaseCoffeeStep(by: CGFloat) {
        SectionManager.coffeeStep += by
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

