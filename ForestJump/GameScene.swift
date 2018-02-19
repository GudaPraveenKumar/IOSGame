//
//  GameScene.swift
//  ForestJump
//
//  Created by Praveen Guda on 1/22/18.
//  Copyright © 2018 Praveen Guda. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsValues {
    static let Player : UInt32 = 0x1 << 1
    static let Obstacle : UInt32 = 0x1 << 2
    static let Score : UInt32 = 0x1 << 3
    static let Coin : UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var Player = SKSpriteNode()
    var Ground = SKSpriteNode()
    var background = SKSpriteNode()
    var TextureAtlas = SKTextureAtlas()
    var TextureArray = [SKTexture]()
    var ImageName: String?
    var bg = SKSpriteNode()
    var gameStarted = Bool()
    var ObstacleNode = SKNode()
    var obstaclePair = SKNode()
    var score = Int()
    var coin = Int()
    var ScoreLabel = SKLabelNode()
    var PlayerDied = Bool()
    var restartBtn = SKSpriteNode()
    var quitBtn = SKSpriteNode()
    var obstacleSpeed = 2
    var time = Double()
    
    // ================ This function gets triggered whenever restart btn is clicked ============
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        PlayerDied = false
        gameStarted = false
        score = 0
        coin = 0
        createScene()
    }
    
    func createScene(){
       
        
        self.physicsWorld.contactDelegate = self
        
        // ================ Adding Score =============
        ScoreLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height / 2 + self.frame.height / 2.5)
        ScoreLabel.text = "Score \(score)  Coins \(coin)"
        ScoreLabel.fontName = "04b_19"
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
        Ground.position = CGPoint(x: self.frame.width/2, y: 0+Ground.frame.height/5)
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
        Player.physicsBody?.categoryBitMask = PhysicsValues.Player
        Player.physicsBody?.collisionBitMask = PhysicsValues.Obstacle
        Player.physicsBody?.contactTestBitMask = PhysicsValues.Obstacle | PhysicsValues.Score | PhysicsValues.Coin
        Player.zPosition = 8
        Player.physicsBody?.angularVelocity = 0
        Player.physicsBody?.allowsRotation = false
        Player.name = "Actor"
        self.addChild(Player)
        
    }
    
    override func didMove(to view: SKView) {
        
        createScene()
        
    }
    
    //  ============== Restart button gets created =================
    func createBtn(){
        restartBtn = SKSpriteNode(imageNamed: "RestartBtn-1")
        restartBtn.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        restartBtn.size = CGSize(width: 170, height: 50)
        restartBtn.zPosition = 12
        
        quitBtn = SKSpriteNode(imageNamed: "QuitBtn")
        quitBtn.position = CGPoint(x: self.frame.width/2, y: self.frame.height/3)
        quitBtn.size = CGSize(width: 170, height: 50)
        quitBtn.zPosition = 12
        
        self.run(SKAction.playSoundFileNamed("playerDied.wav", waitForCompletion: true))
        self.addChild(restartBtn)
        self.addChild(quitBtn)
        
    }
    
    //  ============== Code for checking collisions  ==============
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsValues.Score && secondBody.categoryBitMask == PhysicsValues.Player || firstBody.categoryBitMask == PhysicsValues.Player && secondBody.categoryBitMask == PhysicsValues.Score{
            
            score = score + 1
            ScoreLabel.text = "Score \(score)  Coins \(coin)"
            
        }
        
        if firstBody.categoryBitMask == PhysicsValues.Coin && secondBody.categoryBitMask == PhysicsValues.Player{
            
            coin = coin + 1
            ScoreLabel.text = "Score \(score)  Coins \(coin)"
            self.run(SKAction.playSoundFileNamed("Score.wav", waitForCompletion: true))
            Collectcoins(coinNode: firstBody.node as! SKSpriteNode)
            
        }
        
        if firstBody.categoryBitMask == PhysicsValues.Player && secondBody.categoryBitMask == PhysicsValues.Coin{
            
            coin = coin + 1
            ScoreLabel.text = "Score \(score) Coins \(coin)"
            self.run(SKAction.playSoundFileNamed("Score.wav", waitForCompletion: true))
            Collectcoins(coinNode: secondBody.node as! SKSpriteNode)
        }
        
        if firstBody.categoryBitMask == PhysicsValues.Player && secondBody.categoryBitMask == PhysicsValues.Obstacle || firstBody.categoryBitMask == PhysicsValues.Obstacle && secondBody.categoryBitMask == PhysicsValues.Player{
            
            PlayerDied = true
            gameStarted = false
            Player.removeFromParent()
            enumerateChildNodes(withName: "obstaclePair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            enumerateChildNodes(withName: "Actor", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            // =============== Calling createBtn function to add restart btn ==========
            createBtn()
            
            
        }
        
    }
    
    func Collectcoins(coinNode: SKSpriteNode){
        coinNode.removeFromParent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameStarted == false{
            gameStarted = true
            Player.physicsBody?.affectedByGravity = true
             Player.physicsBody?.angularVelocity = 0
            // ============== Action for calling the add walls ==============
            
            let spawn = SKAction.run({
                () in
                if(self.gameStarted == true){
                    self.addObstacles()
                }
            
            })
            
            // ============== Action for 1.5 seconds of time delay ============
            let delay = SKAction.wait(forDuration: TimeInterval(obstacleSpeed))
            
            // ============== The above both actions are added in sequence to run ==========
            let spawnDelay = SKAction.sequence([spawn, delay])
            
            // ============== Action for repeating the above sequence forever ===========
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            
            // ============== Running the spawndelayforever action =============
            self.run(spawnDelayForever)
            
            // ============== moving the player upwards when user tap on screen ============
            
            Player.run(SKAction.repeatForever(SKAction.animate(with: TextureArray, timePerFrame: 0.1)))
           
        }else{
            
            if(PlayerDied == true){
                
            }else{
                // ============== moving the player when user tap on screen ===============
        
                if(Player.position.y < 97){
                    Player.physicsBody?.velocity = CGVector(dx: 0,dy: 0)
                    Player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 185))
                }
            }
            
        }
        
        for touch in touches{
            
            let location = touch.location(in: self)
            if(PlayerDied == true){
                
                if restartBtn.contains(location){
                    restartScene()
                }
                
                if quitBtn.contains(location){
                    exit(0)
                }
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // ============== Moving the background ================
         if gameStarted == true{
            enumerateChildNodes(withName: "background") { (node, error) in
                self.bg = node as! SKSpriteNode
                self.bg.position = CGPoint(x: self.bg.position.x-2, y: self.bg.position.y)
                
                if(self.bg.position.x <= -self.bg.size.width){
                    self.bg.position = CGPoint(x:self.bg.position.x + self.bg.size.width * 2-15, y: self.bg.position.y)
                }
            }
        }
    }
    
    // ============== Function for adding obstacles ==============
    func addObstacles(){
        
        obstaclePair = SKNode()
        obstaclePair.name = "obstaclePair"
        
        // ============== obstacle properties defined here ==============
        let obstacle = SKSpriteNode(imageNamed: "box")
        obstacle.position = CGPoint(x: self.frame.width, y: Ground.frame.height)
        obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacle.frame.height/3)
        obstacle.physicsBody?.isDynamic = false
        obstacle.setScale(0.5)
        obstacle.physicsBody?.affectedByGravity = false
        obstacle.physicsBody?.categoryBitMask = PhysicsValues.Obstacle
        obstacle.physicsBody?.collisionBitMask = PhysicsValues.Player
        obstacle.physicsBody?.contactTestBitMask = PhysicsValues.Player
        obstacle.zPosition = 8
        obstaclePair.addChild(obstacle)
        
        // ============== obstacles moves in the left direction ==============
        
        let distance = CGFloat(self.frame.width + obstaclePair.frame.width)
        
        let moveTargets = SKAction.moveBy(x: -distance, y: 0, duration: TimeInterval(timeForScore()))
        let removeTargets = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveTargets,removeTargets])
        
        // ============== Adding score node ===============
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 4, height: 500)
        scoreNode.position = CGPoint(x: self.frame.width, y: Ground.frame.height+obstacle.frame.height)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.isDynamic = true
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsValues.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsValues.Player
        obstaclePair.addChild(scoreNode)
        
        // ============== Adding coin node ===============
        let coinNode = SKSpriteNode(imageNamed: "coin")
        coinNode.size = CGSize(width: 40, height: 40)
        coinNode.position = CGPoint(x: self.frame.width, y: self.frame.height/2.5)
        coinNode.physicsBody = SKPhysicsBody(circleOfRadius: coinNode.frame.height/3)
        coinNode.physicsBody?.isDynamic = false
        coinNode.physicsBody?.affectedByGravity = false
        coinNode.physicsBody?.categoryBitMask = PhysicsValues.Coin
        coinNode.physicsBody?.collisionBitMask = 0
        coinNode.physicsBody?.contactTestBitMask = PhysicsValues.Player
        coinNode.zPosition = 8
        obstaclePair.addChild(coinNode)
        
        obstaclePair.run(moveAndRemove)
        self.addChild(obstaclePair)
        
    }
    
    // Specifies the time duration for the given score
    // Tweak this function to reduce/ increase the speed/score ratio
    func timeForScore() -> Double {
        time = 3.5
        if(score > 7 && score < 14){
            time = 3.0
        }
        if(score > 14 && score < 21){
            time = 2.5
        }
        if(score > 21 && score < 28){
            time = 2.0
        }
        if(score > 28 && score < 35){
            time = 1.5
        }
        return time
    }
   
}
