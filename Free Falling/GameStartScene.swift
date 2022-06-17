//
//  GameScene.swift
//  Free Falling
//
//  Created by Alumne on 20/5/22.
//

import SpriteKit
import GameplayKit

class GameStartScene: SKScene {

    let startButton = SKLabelNode(fontNamed: "LilitaOne")

    
    override func sceneDidLoad(){
        self.backgroundColor = .cyan
        
        let titleText = SKLabelNode(fontNamed: "LilitaOne")
        titleText.text = "FREE FALL"
        titleText.verticalAlignmentMode = .center
        titleText.fontSize = 130
        titleText.fontColor = .black
        titleText.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        
        self.addChild(titleText)


        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let waitTransition = SKAction.wait(forDuration: 1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let seq = SKAction.sequence([fadeIn, waitTransition, fadeOut])

        
        startButton.text = "PRESS TO PLAY"
        titleText.verticalAlignmentMode = .center
        startButton.fontSize = 100
        startButton.fontColor = .black
        startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.3)
        self.addChild(startButton)
        startButton.run(SKAction.repeatForever(seq))

    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            let touchPos = touch.location(in: self)

            let gameScene = GameScene(fileNamed: "GameScene")
            gameScene?.scaleMode = self.scaleMode
            let myTransition = SKTransition.fade(withDuration: 0.5)
            self.view!.presentScene(gameScene!, transition: myTransition)

        }
    }

}
