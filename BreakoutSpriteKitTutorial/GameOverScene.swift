//
//  GameOverScene.swift
//  BreakoutSpriteKitTutorial
//
//  Created by ZhouHao on 9/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
   
    init(size: CGSize,isWon : Bool) {
        super.init(size : size)
        
        let background = SKSpriteNode(imageNamed: "bg.png")
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        addChild(background)
        
        // 1
        let gameOverLabel = SKLabelNode(fontNamed: "Arial")
        gameOverLabel.fontSize = 42
        gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        if (isWon) {
            gameOverLabel.text = "Game Won"
        } else {
            gameOverLabel.text = "Game Over"
        }
        addChild(gameOverLabel)
    
    }
 
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        
        let breakoutGameScene =  MyScene(size: self.size)
        // 2
        self.view.presentScene(breakoutGameScene)
    }
}
