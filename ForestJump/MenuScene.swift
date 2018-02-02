//
//  MenuScene.swift
//  ForestJump
//
//  Created by Praveen Guda on 1/30/18.
//  Copyright © 2018 Praveen Guda. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: NSObject {
    
    
    
  override func didMove(to view: SKView){
        var GameTitle = SKLabelNode()
        var NewGameBtn = SKSpriteNode()
        var DifficultyBtn = SKSpriteNode()
        var DifficultyLabel = SKLabelNode()
        
        GameTitle.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        GameTitle.text = "Forest Jump"
    }
    

}
