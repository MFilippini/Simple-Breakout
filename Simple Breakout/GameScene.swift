//
//  GameScene.swift
//  Simple Breakout
//
//  Created by Michael Filippini on 7/12/18.
//  Copyright © 2018 Michael Filippini. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKShapeNode()
    var paddle = SKSpriteNode()
    var loseZone = SKSpriteNode()
    var lives = 3
    var label = SKLabelNode(text: "Lives:")
    let colorArray = [UIColor.red,UIColor.blue,UIColor.green]
    
    
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        createLabel()
        createBackground()
        makeBall()
        makePaddle()
        cloneBricks()
        makeLoseZone()
        makeTopDeflectors()
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: -4, dy: -6))
    }
    
    func createBackground() {
        let stars = SKTexture(imageNamed: "stars")
        for i in 0...1 {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1
            starsBackground.position = CGPoint(x: 0, y: starsBackground.size.height * CGFloat(i))
            addChild(starsBackground)
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let moveReset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            starsBackground.run(moveForever)
        }
    }
    
    func makeBall() {
        ball = SKShapeNode(circleOfRadius: 10)
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.strokeColor = .black
        ball.fillColor = .yellow
        ball.name = "ball"
        
        // physics shape matches ball image
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        // ignores all forces and impulses
        //ball.physicsBody?.isDynamic = false
        // use precise collision detection
        ball.physicsBody?.usesPreciseCollisionDetection = true
        // no loss of energy from friction
        ball.physicsBody?.friction = 0
        // gravity is not a factor
        ball.physicsBody?.affectedByGravity = false
        // bounces fully off of other objects
        ball.physicsBody?.restitution = 1
        // does not slow down over time
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball) // add ball object to the view
    }
    
    func makePaddle() {
        
        paddle = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width/4, height: 20))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        addChild(paddle)
    }
    
    func makeBrick(xVal:Int, yVal:Int, color: UIColor) {
        var brick = SKSpriteNode()
        brick = SKSpriteNode(color: color, size: CGSize(width: 50, height: 20))
        brick.position = CGPoint(x: xVal, y: yVal)
        brick.name = "brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        addChild(brick)
    }
    
    func makeLoseZone() {
        loseZone = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    func makeTopDeflectors(){
        let deflectorLeft = SKShapeNode(circleOfRadius: 20)
        let deflectorRight = SKShapeNode(circleOfRadius: 20)
        deflectorLeft.position = CGPoint(x: frame.minX+7, y: frame.maxY-10)
        deflectorRight.position = CGPoint(x: frame.maxX-9, y: frame.maxY-10)
        deflectorLeft.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        deflectorRight.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        deflectorRight.physicsBody?.isDynamic = false
        deflectorLeft.physicsBody?.isDynamic = false
        deflectorRight.strokeColor = .clear
        deflectorLeft.strokeColor = .clear
        addChild(deflectorRight)
        addChild(deflectorLeft)
    }
    
    func createLabel() {
        label.fontSize = 27
        label.numberOfLines = 2
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.text = "Lives: \(lives)"
        addChild(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "brick" {
            brickContact(brick: contact.bodyA.node as! SKSpriteNode)
        }
        else if contact.bodyB.node?.name == "brick" {
            brickContact(brick: contact.bodyB.node as! SKSpriteNode)
        }
        if contact.bodyA.node?.name == "loseZone" ||
            contact.bodyB.node?.name == "loseZone" {
            livesDown()
            
        }
    }
    
    func livesDown(){
        lives -= 1
        if(lives == 0){
            label.text = "You Lost\nTap to Play Again"
            waitForNewGame()
        }
        else{
            label.text = "Lives: \(lives)"
            ball.removeFromParent()
            ball.position = CGPoint(x: frame.midX, y: frame.midY)
            loseZone.physicsBody?.isDynamic = false
            addChild(ball)
            ball.physicsBody?.isDynamic = true
            ball.physicsBody?.applyImpulse(CGVector(dx: -4, dy: -6))
        }
    }
    
    
    func cloneBricks(){
        var yPos = frame.maxY - 70
        for i in 0...2{
            var xPos = frame.minX + 30
            if i == 1 { xPos = frame.minX + 10 }
            while(xPos < frame.maxX){
                makeBrick(xVal: Int(xPos), yVal: Int(yPos), color: colorArray[i])
                xPos += 55
            }
            yPos -= 30
        }
    }
    
    func brickContact(brick: SKSpriteNode){
        var bricksLeft = false
        if brick.color == .red{
            brick.color = .blue
        }
        else if brick.color == .blue{
            brick.color = .green
        }
        else if brick.color == .green{
            brick.removeFromParent()
        }
        
        for child in children{
            if child.name == "brick" {
                bricksLeft = true
            }
        }
        if !bricksLeft {
            label.text = "You Won!\nTap to Play Again"
            waitForNewGame()
        }
    }
    
    func waitForNewGame(){
        ball.removeFromParent()
        self.view!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(GameScene.resetGame)))
    }
    
    @objc func resetGame(){
        removeAllChildren()
        lives = 3
        createBackground()
        makeBall()
        makePaddle()
        cloneBricks()
        makeLoseZone()
        makeTopDeflectors()
        createLabel()
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: -4, dy: -6))
    }

    
}
