//
//  Info.swift
//  SpriteGame
//
//  Created by Dominik Binar on 14.10.19.
//  Copyright © 2019 RMA. All rights reserved.
//

import SpriteKit


class Info {
    
    var attributes : SKLabelNode
    var counter : Int
    
    init(attributes : SKLabelNode) {
        self.attributes = attributes
        self.counter = 0
    }
    
    func setValues(text : String, size : CGFloat, color : SKColor, position : CGPoint) {
        attributes.text = text
        attributes.fontSize = size
        attributes.fontColor = color
        attributes.position = position
    }
    
    func add(clear : Bool) {
        
        if clear {
            counter = 0
            attributes.text = "Philipps: 0"
        } else {
            counter += 1
            attributes.text = "Philipps: " + String(counter)
        }
    }
    
    func countdown(clear : Bool) {
        if clear {
            counter = 20
            attributes.text = "Philipps: 20"
        } else {
           counter -= 1
            attributes.text = "Philipps: " + String(counter)
        }
    }
}
