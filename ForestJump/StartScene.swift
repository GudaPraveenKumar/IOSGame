//
//  StartScene.swift
//  ForestJump
//
//  Created by Praveen Guda on 2/19/18.
//  Copyright © 2018 Praveen Guda. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {
    
    var gameTitleNode: SKLabelNode!
    var playNode: SKSpriteNode!
    var quitNode: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        
        gameTitleNode = self.childNode(withName: "gameTitle") as! SKLabelNode
        playNode = self.childNode(withName: "playButton") as! SKSpriteNode
        quitNode = self.childNode(withName: "quitButton") as! SKSpriteNode
       
        gameTitleNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height-gameTitleNode.frame.height)
        gameTitleNode.zPosition = 8
        
        playNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height/3)
        quitNode.position = CGPoint(x: self.frame.width/2, y: self.frame.height/6)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        
        if let location = touch?.location(in: self){
            
            let nodesArray = self.nodes(at: location)
            if nodesArray.first?.name == "playButton" {
                let gameScene = GameScene(fileNamed: "GameScene")!
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                gameScene.scaleMode = .aspectFill
                self.view?.presentScene(gameScene, transition: transition)
            }else if nodesArray.first?.name == "quitButton" {
                exit(0)
            }
            
        }
        
    }

}
