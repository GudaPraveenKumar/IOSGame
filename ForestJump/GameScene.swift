//
//  GameScene.swift
//  ForestJump
//
//  Created by Praveen Guda on 1/22/18.
//  Copyright © 2018 Praveen Guda. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var Player = SKSpriteNode()
    var Ground = SKSpriteNode()
    var background = SKSpriteNode()
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    var ImageName: String?
    var bg = SKSpriteNode()
    var gameStarted = Bool()
    var score = Int()
    var ScoreLabel = SKLabelNode()




    func createScene(){

        // ================ Adding Score =============
        ScoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        ScoreLabel.text = "Score \(score)"
        ScoreLabel.zPosition = 8
        self.addChild(ScoreLabel)

        // ================ Adding background =============

        for i in 0..<2{
            background = SKSpriteNode(imageNamed: "mountains_bg")
            background.anchorPoint = CGPoint(x:0,y:0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width,y:0)
            background.name = "background"
            self.addChild(background)
        }

        // ============== Adding ground ===========

        Ground = SKSpriteNode(imageNamed: "ground")
        Ground.setScale(0.75)
        Ground.position = CGPoint(x: self.frame.width/2, y: 0+Ground.frame.height/3)
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.isDynamic = false
        Ground.zPosition = 5

        self.addChild(Ground)

        // ============== Texture for animating the player  ==============

        TextureAtlas = SKTextureAtlas(named: "Player")
        for i in 1...TextureAtlas.textureNames.count{
            ImageName = "player\(i).png"
            TextureArray.append(SKTexture(imageNamed: ImageName!))
        }

        // ============== Adding player ==============
        Player = SKSpriteNode(imageNamed: "player1.png")
        Player.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        Player.size = CGSize(width: 60, height: 80)
        Player.physicsBody = SKPhysicsBody(circleOfRadius: Player.frame.height/2)
        Player.physicsBody?.isDynamic = true
        Player.physicsBody?.affectedByGravity = false

        Player.zPosition = 8
        Player.physicsBody?.allowsRotation = false
        self.addChild(Player)

    }

    override func didMove(to view: SKView) {

      createScene()

    }




    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        // ============== Action for 2 seconds of time delay ============
        let delay = SKAction.wait(forDuration: 2)

        // ============== The above both actions are added in sequence to run ==========
        let spawnDelay = SKAction.sequence([delay])

        // ============== Action for repeating the above sequence forever ===========
        let spawnDelayForever = SKAction.repeatForever(spawnDelay)

        // ============== Running the spawndelayforever action =============
        self.run(spawnDelayForever)

        // ============== moving the player upwards when user tap on screen ============

        Player.run(SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.1)))
        Player.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
        Player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))

    }

    override func update(_ currentTime: TimeInterval) {

    }



}
