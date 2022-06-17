//
//  GameScene.swift
//  Free Falling
//
//  Created by Alumne on 20/5/22.
//

import SpriteKit
import GameplayKit

var gameScore: Int = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var lastUpdateTime : TimeInterval = 0
    private var totalTime: TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var parentClouds: SKNode!
    
    
    
    ///---------------------------------------
    ///---------------------------------------
    /// Here starts my variables
    ///---------------------------------------
    ///---------------------------------------
    
    private var num_clouds = 8
    private var num_platforms = 12
    private var velocityPlatforms: CGFloat = -200
    private var velocityFallClouds = [CGFloat]()
    private var velocityMult: CGFloat = 1
    private var lastIndexChanged: Int = 0
    
    private var flagGameEnded: Bool = false
    
    var scoreLabel = SKLabelNode(fontNamed: "LilitaOne")
    var clouds = [SKSpriteNode]()
    var platforms = [SKSpriteNode]()
    var player = SKSpriteNode()
    var TextureArray = [SKTexture]()
    var coins = [SKSpriteNode]()
    
    struct PhysicsMasks{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 // 1
        static let Coin: UInt32 = 0b10 // 2
        static let Platform: UInt32 = 0b100 // 4
    }
    
    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0

        scoreLabel.text = "SCORE: 0"
        scoreLabel.zPosition = 3
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = .black
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 10 - self.size.width/2, y: self.size.height/2 - 10)
        self.addChild(scoreLabel)
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        for i in 0...6{
            TextureArray.append(SKTexture(imageNamed: "player_\(i)"))
        }
        // Generates player
        self.player = SKSpriteNode(texture: TextureArray[0])
        self.player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width - 70 , height: 20), center: CGPoint(x: 0, y: -37))
        self.player.physicsBody!.restitution = 0
        self.player.physicsBody!.allowsRotation = false
        self.player.physicsBody!.categoryBitMask = PhysicsMasks.Player
        self.player.physicsBody!.collisionBitMask = PhysicsMasks.Platform
        self.player.physicsBody!.contactTestBitMask = PhysicsMasks.Coin
        self.addChild(self.player)
        
        // Generates all clouds
        for i in 0...num_clouds
        {
            clouds.append(SKSpriteNode(imageNamed: "cloud" + String(i + 1)))
            clouds[i].position = CGPoint(x: i * 100 - Int(self.size.width/2), y: Int.random(in: Int(-self.size.height/2)...Int(self.size.height/2)))
            clouds[i].zPosition = -1
            self.addChild(self.clouds[i])
            velocityFallClouds.append(CGFloat.random(in: -300 ... -50))
        }
        for i in 1...num_clouds
        {
            clouds.append(SKSpriteNode(imageNamed: "cloud" + String(i + 1)))
            clouds[num_clouds+i].position = CGPoint(x: i * 100 - Int(self.size.width/2), y: Int.random(in: Int(-self.size.height/2)...Int(self.size.height/2)))
            clouds[num_clouds+i].zPosition = -1
            self.addChild(self.clouds[num_clouds+i])
            velocityFallClouds.append(CGFloat.random(in: -300 ... -50))
        }
        // Generate platforms
        for i in 0...num_platforms{
            if(Int.random(in: 0...1) == 0){
                platforms.append(SKSpriteNode(imageNamed: "ground_wood"))
            }
            else{
                platforms.append(SKSpriteNode(imageNamed: "ground_wood_small"))
            }
            
            platforms[i].position = CGPoint(x: i * 100 - Int(self.size.width/2), y: Int.random(in: Int(-self.size.height/2)...Int(self.size.height/2)))
            platforms[i].physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: platforms[i].size.width, height: platforms[i].size.height))
            platforms[i].physicsBody!.categoryBitMask = PhysicsMasks.Platform
            platforms[i].physicsBody!.collisionBitMask = PhysicsMasks.Player
            platforms[i].physicsBody!.isDynamic = false
            
            self.addChild(self.platforms[i])
        }
        platforms[0].position = CGPoint(x: 0, y: -50)

        gameScore = 0
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        var moveAction: SKAction
        var animationAction: SKAction
        
        if pos.x > 0{
            moveAction = SKAction.move(by: CGVector(dx: 50*self.velocityMult, dy: 0), duration: 0.25)
            animationAction = SKAction.animate(with: [TextureArray[1],TextureArray[2],TextureArray[3]], timePerFrame: 0.1)
        }
        else{
            moveAction = SKAction.move(by: CGVector(dx: -50*self.velocityMult, dy: 0), duration: 0.25)
            animationAction = SKAction.animate(with: [TextureArray[4],TextureArray[5],TextureArray[6]], timePerFrame: 0.1)
        }
        //let moveActionSeq = SKAction.sequence([moveAction])
        
        self.player.run(SKAction.repeatForever(moveAction), withKey: "moving")
        self.player.run(SKAction.repeatForever(animationAction), withKey: "animation")
    }
    
    func touchUp(atPoint pos : CGPoint) {
        self.player.removeAction(forKey: "moving")
        self.player.removeAction(forKey: "animation")
        self.player.texture = TextureArray[0]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        //for t in touches { self.touchDown(atPoint: t.location(in: self)) }
        let touchPos = touches.first!.location(in: self)
        self.touchMoved(toPoint: touchPos)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPos = touches.first!.location(in: self)
        self.touchMoved(toPoint: touchPos)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchUp(atPoint: touches.first!.location(in: self))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if flagGameEnded{ return }
        // Called before each frame is rendered
        //self.position.y -= 10;
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        

        
        
        // Calculate time since last update
        let dt: CGFloat = currentTime - self.lastUpdateTime
        self.totalTime += dt
        
        if totalTime > 5{
            velocityMult += 0.4
            self.totalTime -= 5
        }
        
        for i in 0...num_clouds*2{
            let velocityAdded = velocityFallClouds[i] * dt
            clouds[i].position.y-=velocityAdded
            if(clouds[i].position.y > self.size.height/2 + 30){
                clouds[i].position.y = -self.size.height/2 - 30
                clouds[i].position.x = CGFloat.random(in: -self.size.width/2...self.size.width/2)
            }
        }
        for i in 0...num_platforms{
            var velocityAdded = velocityPlatforms * dt
            velocityAdded *= velocityMult
            platforms[i].position.y-=velocityAdded
            
            if(platforms[i].position.y > self.size.height/2 + 30){
                
                platforms[i].position.y = -self.size.height/2 - 30 - CGFloat.random(in: 0...100)
                if(platforms[i].position.y > platforms[lastIndexChanged].position.y){
                    platforms[i].position.y = platforms[lastIndexChanged].position.y - 30 - CGFloat.random(in: 80...300)
                }
                var aux = CGFloat.random(in: 50...200)
                let rand = Int.random(in: 0...1)
                if(rand == 0){
                    aux *= -1
                }
                platforms[i].position.x = CGFloat.random(in: -self.size.width/2+100...self.size.width/2-100)
                //platforms[lastIndexChanged].position.x + aux //CGFloat.random(in: -self.size.width/2+100...self.size.width/2-100)
                lastIndexChanged = i
                
                // Can generate a coin
                
                let coinProb = Int.random(in: 0...3)
                if coinProb == 0{
                    coins.append(SKSpriteNode(imageNamed: "coin"))
                        guard coins.last != nil else {
                            return
                        }
                    coins.last!.position = CGPoint(x: 0, y: 55 )
                    coins.last!.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50 , height: 50))
                    coins.last!.physicsBody!.isDynamic = true
                    coins.last!.physicsBody!.affectedByGravity = false
                    coins.last!.physicsBody!.categoryBitMask = PhysicsMasks.Coin
                    coins.last!.physicsBody!.collisionBitMask = PhysicsMasks.None
                    coins.last!.physicsBody!.contactTestBitMask = PhysicsMasks.Player
                    coins.last!.size = CGSize(width: 50, height: 50)
                    self.platforms[i].addChild(self.coins.last!)
                }
            }
        }
        
        if(player.position.x < -self.size.width/2){
            player.position.x = self.size.width/2 - 10
        }
        else if(player.position.x > self.size.width/2){
            player.position.x = -self.size.width/2 + 10
        }
        if player.position.y < -self.size.height/2 - 100 || player.position.y > self.size.height/2 + 50{
            endGame()
        }
        self.lastUpdateTime = currentTime
    }
    
    
    func getCoin(_coin: SKSpriteNode){
        
        if _coin.name != ""{
            _coin.name = ""
            _coin.physicsBody!.isDynamic = false
            _coin.physicsBody!.contactTestBitMask = PhysicsMasks.None
            
            let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let group = SKAction.group([scaleOut, fadeOut])
            let seq = SKAction.sequence([group, .removeFromParent()])
            _coin.run(seq)
            
            gameScore += 1
            
            scoreLabel.text = "SCORE: \(gameScore)"
        }
    }
    
    func endGame(){
        if flagGameEnded{
            return
        }
        
        flagGameEnded = true
        self.physicsWorld.speed = 0
        self.isUserInteractionEnabled = false

        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.run(changeGameOverScene)
        ])
        )
    }

    func changeGameOverScene(){
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(gameOverScene, transition: myTransition)

    }

    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == PhysicsMasks.Coin && contact.bodyB.categoryBitMask == PhysicsMasks.Player{
            getCoin(_coin: contact.bodyA.node as! SKSpriteNode)
            //contact.bodyA.node?.removeFromParent()
        }
        else if contact.bodyA.categoryBitMask == PhysicsMasks.Player && contact.bodyB.categoryBitMask == PhysicsMasks.Coin{
            getCoin(_coin: contact.bodyB.node as! SKSpriteNode)
            //contact.bodyB.node?.removeFromParent()
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
    }
}
