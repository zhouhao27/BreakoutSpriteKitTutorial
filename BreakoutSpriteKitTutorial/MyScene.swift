//
//  MyScene.swift
//  BreakoutSpriteKitTutorial
//
//  Created by ZhouHao on 9/7/14.
//  Copyright (c) 2014 Zeus Software. All rights reserved.
//

import SpriteKit

let ballCategoryName = "ball"
let paddleCategoryName = "paddle"
let blockCategoryName = "block"
let blockNodeCategoryName = "blockNode"

let ballCategory : UInt32  = 0x1 << 0  // 00000000000000000000000000000001
let bottomCategory : UInt32 = 0x1 << 1 // 00000000000000000000000000000010
let blockCategory : UInt32 = 0x1 << 2  // 00000000000000000000000000000100
let paddleCategory : UInt32 = 0x1 << 3 // 00000000000000000000000000001000

class MyScene: SKScene,SKPhysicsContactDelegate {

    var isFingerOnPaddle : Bool = false
    var isGameOver : Bool = false
    
    let maxSpeed = 400.0
    
    init(size: CGSize) {
        
        super.init(size: size)
        
        let background = SKSpriteNode(imageNamed: "bg.png")
        background.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        addChild(background)
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        
        // setup border
        // 1 Create a physics body that borders the screen
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        // 2 Set physicsBody of scene to borderBody
        self.physicsBody = borderBody
        // 3 Set the friction of that physicsBody to 0
        self.physicsBody.friction = 0.0
        
        // setup ball
        // 1
        let ball = SKSpriteNode(imageNamed: "ball.png")
        ball.name = ballCategoryName
        ball.position = CGPointMake(self.frame.size.width/3, self.frame.size.height/3)
        addChild(ball)
        // 2
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.width/2)
        // 3
        ball.physicsBody.friction = 0.0
        // 4
        ball.physicsBody.restitution = 1.0
        // 5
        ball.physicsBody.linearDamping = 0.0
        // 6
        ball.physicsBody.allowsRotation = false
        
        ball.physicsBody.applyImpulse(CGVectorMake(10.0, -10.0))
        ball.physicsBody.collisionBitMask = paddleCategory
        
        // setup paddle
        let paddle = SKSpriteNode(imageNamed: "paddle.png")
        paddle.name = paddleCategoryName
        paddle.position = CGPointMake(CGRectGetMidX(self.frame), paddle.frame.size.height * 0.6)
        addChild(paddle)
        
        paddle.physicsBody = SKPhysicsBody(rectangleOfSize: paddle.frame.size)
        paddle.physicsBody.restitution = 0.1
        paddle.physicsBody.friction = 0.4
        // make physicsBody static
        paddle.physicsBody.dynamic = false
        
        // setup bottom
        let bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFromRect: bottomRect)
        addChild(bottom)
        
        // setup blocks
        // 1 Store some useful variables
        let numberOfBlocks = 3
        let blockWidth = SKSpriteNode(imageNamed: "block.png").size.width
        let padding = 20.0
        
        // 2 Calculate the xOffset
        let xOffset = (self.frame.size.width - (blockWidth * Double(numberOfBlocks) + padding * (Double(numberOfBlocks-1)))) / 2
        // 3 Create the blocks and add them to the scene
        for (var i = 1 ; i <= numberOfBlocks; i++) {
            let block = SKSpriteNode(imageNamed: "block.png")
            
            block.position = CGPointMake((Double(i)-0.5)*block.frame.size.width + (Double(i)-1.0)*padding + xOffset, self.frame.size.height * 0.8)
            block.physicsBody = SKPhysicsBody(rectangleOfSize: block.frame.size)
            block.physicsBody.allowsRotation = false
            block.physicsBody.friction = 0.0
            block.name = blockCategoryName
            block.physicsBody.categoryBitMask = blockCategory
            block.physicsBody.collisionBitMask = 0
            addChild(block)
        }
        
        // setup categoryBitMasks
        bottom.physicsBody.categoryBitMask = bottomCategory
        ball.physicsBody.categoryBitMask = ballCategory
        paddle.physicsBody.categoryBitMask = paddleCategory
        
        // setup contactTestBitMask
        ball.physicsBody.contactTestBitMask = bottomCategory | blockCategory
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        let touchLocation = touches.anyObject().locationInNode(self) as CGPoint
        
        if let node = self.nodeAtPoint(touchLocation) {
            if node.name != nil && node.name! == paddleCategoryName {
                println("Began touch on paddle")
                self.isFingerOnPaddle = true
            }
        }
        
        // This doesn't work in Swift
        /*
        if let body = self.physicsWorld.bodyAtPoint(touchLocation) as SKPhysicsBody? {
            
            if body.node.name == paddleCategoryName {
                println("Began touch on paddle")
                self.isFingerOnPaddle = true
            }
        }
*/
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        
        // 1 Check whether user tapped paddle
        if self.isFingerOnPaddle {
            // 2 Get touch location
            let touch: AnyObject! = touches.anyObject()
            let touchLocation = touch.locationInNode(self)
            let previousLocation =  touch.previousLocationInNode(self)
            // 3 Get node for paddle
            let paddle = childNodeWithName(paddleCategoryName) as SKSpriteNode
            // 4 Calculate new position along x for paddle
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            // 5 Limit x so that the paddle will not leave the screen to left or right
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, self.size.width - paddle.size.width/2)
            // 6 Update position of paddle
            paddle.position = CGPointMake(paddleX, paddle.position.y)
        }
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        self.isFingerOnPaddle = false
    }
    
    func didBeginContact(contact: SKPhysicsContact!) {
        // 1 Create local variables for two physics bodies
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        // 3 react to the contact between ball and bottom
        if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == bottomCategory) {

            if !isGameOver {
                let gameOverScene = GameOverScene(size: self.frame.size, isWon: false)
                self.view.presentScene(gameOverScene)
                self.isGameOver = true
            }
        }
        
        if (firstBody.categoryBitMask == ballCategory && secondBody.categoryBitMask == blockCategory) {
            secondBody.node.removeFromParent()
            
            if (self.isGameWon()) {
                let gameWonScene = GameOverScene(size: self.frame.size, isWon: true)
                self.view.presentScene(gameWonScene)
            }
        }
    }
    
    func didEndContact(contact: SKPhysicsContact!) {
        
    }
    
    func isGameWon() -> Bool {
        var numberOfBricks = 0
        for node in self.children {
            
            if let spriteNode : SKSpriteNode = node as? SKSpriteNode {
                if spriteNode.name != nil {
                    println(spriteNode.name)
                    if spriteNode.name == blockCategoryName {
                        numberOfBricks++
                    }
                }
            }
        }

        return numberOfBricks <= 0
    }
    
    override func update(currentTime: NSTimeInterval) {
        /* Called before each frame is rendered */
        if let ball = childNodeWithName(ballCategoryName) {

            let speed = sqrt(ball.physicsBody.velocity.dx*ball.physicsBody.velocity.dx + ball.physicsBody.velocity.dy * ball.physicsBody.velocity.dy)
            if (speed > maxSpeed) {
                ball.physicsBody.linearDamping = 0.4
            } else {
                ball.physicsBody.linearDamping = 0.0
            }
        }
    }
}
