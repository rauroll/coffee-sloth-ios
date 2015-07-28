
//
//  EmptySection.swift
//  Coffee Sloth
//
//  Created by Olli Rauramo on 09/07/15.
//  Copyright © 2015 Ollis codes. All rights reserved.
//

import Foundation
import SpriteKit

class EmptySection: Section {
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(width: CGFloat) {
        super.init()
        
        
        self.width = width
        self.weight = 15
    }
    
    override init() {
        super.init()
        
        self.width = 200.0
    }
    
    override func enqueued() {
        //print("Enqueued an empty section")
    }
}