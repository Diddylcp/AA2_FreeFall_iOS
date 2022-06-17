//
//  GameScene.swift
//  Free Falling
//
//  Created by Alumne on 20/5/22.
//

import SpriteKit
import GameplayKit

class GameStartSceneNew: SKScene {

    let restartButton = SKLabelNode(fontNamed: "LilitaOne")
    
    override func didMove(to view: SKView){
        self.backgroundColor = .green
        
        let gameOverText = SKLabelNode(fontNamed: "LilitaOne")
        gameOverText.text = "GAME OVER"
        gameOverText.fontSize = 120
        gameOverText.fontColor = .black
        gameOverText.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        //gameOverText.position = CGPoint(x: 0, y: 0)
        self.addChild(gameOverText)

        let scoreText = SKLabelNode(fontNamed: "LilitaOne")
        scoreText.text = "SCORE: \(gameScore)"
        scoreText.fontSize = 100
        scoreText.fontColor = .black
        scoreText.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        self.addChild(scoreText)

        let defaults = UserDefaults()
        var highScore = defaults.integer(forKey: "highScore")

        if highScore < gameScore{
            highScore = gameScore
            defaults.set(highScore, forKey: "highScore")
            //defaults.set(highScore, forKey: "highScore")
        }

        let highScoreText = SKLabelNode(fontNamed: "LilitaOne")
        highScoreText.text = "HIGH SCORE: \(highScore)"
        highScoreText.fontSize = 70
        highScoreText.fontColor = .black
        highScoreText.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
        self.addChild(highScoreText)

        
        restartButton.text = "PLAY AGAIN"
        restartButton.fontSize = 50
        restartButton.fontColor = .black
        restartButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.2)
        self.addChild(restartButton)

    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let touchPos = touch.location(in: self)

            if restartButton.contains(touchPos){
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(gameScene!, transition: myTransition)
            }
        }
    }

}
