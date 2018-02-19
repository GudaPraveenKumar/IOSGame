//
//  Menu.swift
//  ForestJump
//
//  Created by Praveen Guda on 2/19/18.
//  Copyright © 2018 Praveen Guda. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameMenu: SKScene {
    //Creating variables for Game Menu
    var NewGameBtn: SKSpriteNode!
    var QuitGameBtn : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        NewGameBtn = self.childNode(withName: "NewGameBtn") as! SKSpriteNode
        QuitGameBtn = self.childNode(withName: "QuitGameBtn") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        if let location = touch?.location(in: self){
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "NewGameBtn" {
                let gameScene = GameScene(fileNamed: "GameScene")!
                let transition = SKTransition.flipHorizontal(withDuration: 1)
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: transition)
            } else if nodesArray.first?.name == "QuitGameBtn" {
                quit()
            }
            
        }
        
        
    }
    
    func quit() {
        exit(0)
    }
    
}
