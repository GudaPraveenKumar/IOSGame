//
//  GetRandomValues.swift
//  ForestJump
//
//  Created by Praveen Guda on 1/28/18.
//  Copyright © 2018 Praveen Guda. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    
    public static func random() -> CGFloat{
        return CGFloat(Float(arc4random())/0xFFFFFFFF)
    }
    
    public static func random(min:CGFloat, max: CGFloat) -> CGFloat{
        return CGFloat.random() * (max - min) + min
    }
    
}

