//
//  GamePlayScene.swift
//  Dot&Dash
//
//  Created by mac on 14/10/28.
//  Copyright (c) 2014年 TenPercent. All rights reserved.
//

import SpriteKit

class GamePlayScene: SKScene, SKPhysicsContactDelegate {
    
    let MASK_HOME: UInt32 = 0b1
    let MASK_CLEAN: UInt32 = 0b10
    let MASK_TIME: UInt32 = 0b100
    let MASK_BOMB: UInt32 = 0b1000
    let MASK_DOT: UInt32 = 0b10000
    var score: Int = 0
    var level: Int = 1
    var combo: Int = 1
    var oldTime: Int = 0
    var countdown: Int = 30
    var gravity: CGFloat = 0.0
    var moving: Bool = false
    let All = SKNode()
    var DashList = [SKSpriteNode]()
    let CountdownLabel = SKLabelNode(fontNamed: "Futura")
    let ScoreLabel = SKLabelNode(fontNamed: "Futura")
    let LevelLabel = SKLabelNode(fontNamed: "Futura")
    
    override init(size: CGSize) {
        super.init(size: size)
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame)
        physicsWorld.gravity = CGVectorMake(0.0, -1.0)
        physicsWorld.contactDelegate = self
        var randomChance = arc4random() % 7
        switch randomChance {
        case 0: backgroundColor = UIColor.blueColor()
        case 1: backgroundColor = UIColor.grayColor()
        case 2: backgroundColor = UIColor.brownColor()
        case 3: backgroundColor = UIColor.greenColor()
        case 4: backgroundColor = UIColor.orangeColor()
        case 5: backgroundColor = UIColor.purpleColor()
        case 6: backgroundColor = UIColor.magentaColor()
        default: break
        }
        CountdownLabel.text = "30"
        CountdownLabel.fontSize = 30
        CountdownLabel.fontColor = SKColor(red: 0, green: 161/255, blue: 233/255, alpha: 1)
        CountdownLabel.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame))
        addChild(CountdownLabel)
        ScoreLabel.text = "Score: 0"
        ScoreLabel.fontSize = 15
        ScoreLabel.fontColor = UIColor.blackColor()
        ScoreLabel.position = CGPointMake(frame.size.width * 0.12, frame.size.height * 0.95)
        addChild(ScoreLabel)
        LevelLabel.text = "Level: 1"
        LevelLabel.fontSize = 15
        LevelLabel.fontColor = UIColor.blackColor()
        LevelLabel.position = CGPointMake(frame.size.width * 0.88, frame.size.height * 0.95)
        addChild(LevelLabel)
        let Home = SKSpriteNode(color: UIColor.whiteColor(), size: CGSize(width: size.width, height: 20))
        Home.position = CGPoint(x: size.width/2, y: 0)
        Home.physicsBody = SKPhysicsBody(rectangleOfSize: Home.size)
        Home.physicsBody?.contactTestBitMask = MASK_HOME
        Home.physicsBody?.dynamic = false
        addChild(Home)
        addChild(All)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        moving = true
        let Dash = SKSpriteNode(imageNamed: "Dash")
        Dash.position = (touches as NSSet).anyObject()!.locationInNode(self)
        Dash.physicsBody = SKPhysicsBody(rectangleOfSize: Dash.frame.size)
        Dash.physicsBody?.dynamic = false
        All.addChild(Dash)
        DashList.append(Dash)
        if DashList.count > 30 {
            DashList[0].removeFromParent()
            DashList.removeRange(0...0)
        }
        let fadeAction = SKAction.fadeOutWithDuration(10)
        Dash.runAction(SKAction.sequence([fadeAction, SKAction.removeFromParent()]))
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if moving == false {
                let Dot = SKSpriteNode(imageNamed: "Dot")
                Dot.position = (touches as NSSet).anyObject()!.locationInNode(self)
                Dot.physicsBody = SKPhysicsBody(circleOfRadius: Dot.size.width/2)
                Dot.physicsBody?.restitution = 1.0
                Dot.physicsBody?.linearDamping = 0.0
                Dot.physicsBody?.velocity = CGVector(dx: 0, dy: 500)
                Dot.physicsBody?.contactTestBitMask = MASK_DOT
                let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
                Dot.runAction(SKAction.repeatActionForever(action))
                All.addChild(Dot)
            runAction(SKAction.playSoundFileNamed("dot.wav", waitForCompletion: false))
            let dot = SKLabelNode(fontNamed: "Futura")
            dot.text = "-1"
            dot.fontSize = 20
            dot.position = CountdownLabel.position
            addChild(dot)
            let moveAction = SKAction.moveBy(CGVector(dx: 0, dy: -30), duration: 1)
            dot.runAction(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
            countdown--
        }
        moving = false
    }
    
    func spawnTime(x: Int) {
        let Time = SKSpriteNode(imageNamed: "Time")
        Time.position = CGPointMake(CGFloat(x), CGFloat(frame.size.height))
        Time.physicsBody = SKPhysicsBody(circleOfRadius: Time.size.width/2)
        Time.physicsBody?.restitution = 1.0
        Time.physicsBody?.contactTestBitMask = MASK_TIME
        All.addChild(Time)
    }
    
    func spawnBomb(x: Int) {
        let Bomb = SKSpriteNode(imageNamed: "Bomb")
        Bomb.position = CGPointMake(CGFloat(x), CGFloat(frame.size.height))
        Bomb.physicsBody = SKPhysicsBody(circleOfRadius: Bomb.size.width/2)
        Bomb.physicsBody?.restitution = 1.0
        Bomb.physicsBody?.contactTestBitMask = MASK_BOMB
        All.addChild(Bomb)
    }
    
    func spawnClean(x: Int) {
        let Clean = SKSpriteNode(imageNamed: "Clean")
        Clean.position = CGPointMake(CGFloat(x), CGFloat(frame.size.height))
        Clean.physicsBody = SKPhysicsBody(circleOfRadius: Clean.size.width/2)
        Clean.physicsBody?.restitution = 1.0
        Clean.physicsBody?.contactTestBitMask = MASK_CLEAN
        All.addChild(Clean)
    }
    
    func spawn() {
        var randomChance = arc4random() % 41
        let width = UInt32(UInt(frame.size.width))
        let randomWidth = Int(arc4random() % width)
        var x = randomWidth
        switch randomChance {
        case 0...19: spawnTime(x)
        case 20...39: spawnBomb(x)
        case 40: spawnClean(x)
        default: break
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if (contact.bodyA?.node != nil) && (contact.bodyB?.node != nil) {
            switch contact.bodyA.contactTestBitMask|contact.bodyB.contactTestBitMask {
            case MASK_BOMB|MASK_HOME:
                self.view?.presentScene(GameOverScene(size: self.size, score: self.score), transition: SKTransition.fadeWithDuration(0.4))

            case MASK_TIME|MASK_HOME:
                let time = SKLabelNode(fontNamed: "Futura")
                time.text = "+2"
                time.fontSize = 20
                time.fontColor = SKColor(red: 0, green: 161/255, blue: 233/255, alpha: 1)
                time.position = CountdownLabel.position
                addChild(time)
                let moveAction = SKAction.moveBy(CGVector(dx: 0, dy: 30), duration: 1)
                time.runAction(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                switch contact.bodyA.contactTestBitMask {
                case MASK_HOME: contact.bodyB.node?.removeFromParent()
                case MASK_TIME: contact.bodyA.node?.removeFromParent()
                default: break
                }
                countdown += 2
                runAction(SKAction.playSoundFileNamed("Time|Home.mp3", waitForCompletion: false))
                
            case MASK_CLEAN|MASK_HOME:
                switch contact.bodyA.contactTestBitMask {
                case MASK_HOME: contact.bodyB.node?.removeFromParent()
                case MASK_CLEAN: contact.bodyA.node?.removeFromParent()
                default: break
                }
                
            case MASK_DOT|MASK_BOMB:
                if let nodeA = contact.bodyA?.node {
                    if let nodeB = contact.bodyB?.node {
                        let bonus = SKLabelNode(fontNamed: "Futura")
                        bonus.text = NSString(format: "+%ld", combo) as String
                        bonus.fontSize = 20
                        switch combo {
                        case 1: bonus.fontColor = UIColor.whiteColor()
                        case 2: bonus.fontColor = UIColor.yellowColor()
                        case 3: bonus.fontColor = UIColor.greenColor()
                        case 4: bonus.fontColor = UIColor.blueColor()
                        case 5: bonus.fontColor = UIColor.redColor()
                        case 6: bonus.fontColor = UIColor.purpleColor()
                        default: bonus.fontColor = UIColor.blackColor()
                        }
                        bonus.position.x = (nodeA.position.x + nodeB.position.x) / 2
                        bonus.position.y = (nodeA.position.y + nodeB.position.y) / 2
                        addChild(bonus)
                        let moveAction = SKAction.moveBy(CGVector(dx: 0, dy: 10), duration: 1)
                        bonus.runAction(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                        switch contact.bodyA.contactTestBitMask {
                        case MASK_DOT: contact.bodyB.node?.removeFromParent()
                        case MASK_BOMB: contact.bodyA.node?.removeFromParent()
                        default: break
                        }
                    }
                }
                score += combo
                combo++
                
            case MASK_DOT|MASK_TIME:
                if let nodeA = contact.bodyA?.node {
                    if let nodeB = contact.bodyB?.node {
                        let remove = SKLabelNode(fontNamed: "Futura")
                        remove.text = "!"
                        remove.fontSize = 20
                        remove.position.x = (nodeA.position.x + nodeB.position.x) / 2
                        remove.position.y = (nodeA.position.y + nodeB.position.y) / 2
                        addChild(remove)
                        let moveAction = SKAction.moveBy(CGVector(dx: 0, dy: 10), duration: 1)
                        remove.runAction(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                        contact.bodyA.node?.removeFromParent()
                        contact.bodyB.node?.removeFromParent()
                    }
                }
                combo = 1
                
            case MASK_DOT|MASK_CLEAN:
                if let nodeA = contact.bodyA?.node {
                    if let nodeB = contact.bodyB?.node {
                        let clean = SKLabelNode(fontNamed: "Futura")
                        clean.text = "+5"
                        clean.fontSize = 40
                        clean.fontColor = SKColor(red: 0, green: 161/255, blue: 233/255, alpha: 1)
                        clean.position.x = (nodeA.position.x + nodeB.position.x) / 2
                        clean.position.y = (nodeA.position.y + nodeB.position.y) / 2
                        addChild(clean)
                        let moveAction = SKAction.moveBy(CGVector(dx: 0, dy: 10), duration: 1)
                        clean.runAction(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
                        All.removeAllChildren()
                        runAction(SKAction.playSoundFileNamed("clean.mp3", waitForCompletion: false))
                    }
                }
                countdown += 5
                
            default: break
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if Int(currentTime) >= Int(oldTime + 1) {
            spawn()
            spawn()
            countdown--
            if countdown <= 0 {
                self.view?.presentScene(GameOverScene(size: self.size, score: self.score), transition: SKTransition.fadeWithDuration(0.4))
                runAction(SKAction.playSoundFileNamed("GameOver.mp3", waitForCompletion: false))
            }
        }
        if countdown <= 10 {
            CountdownLabel.fontColor = UIColor.redColor()
        } else {
            CountdownLabel.fontColor = SKColor(red: 0, green: 161/255, blue: 233/255, alpha: 1)
        }
        switch score {
        case 0..<100: level = 1
        case 100..<500: level = 2
        case 500..<1000: level = 3
        case 1000..<2000: level = 4
        case 2000..<3000: level = 5
        case 3000..<5000: level = 6
        case 5000..<7000: level = 7
        case 7000..<10000: level = 8
        default: level = 9
        }
        oldTime = Int(currentTime)
        CountdownLabel.text = String(countdown)
        ScoreLabel.text = "Score: " + String(score)
        LevelLabel.text = "Level: " + String(level)
        physicsWorld.gravity = CGVectorMake( 0.0, (gravity - CGFloat(level)))
    }
}