//
//  GameOverScene.swift
//  Dot&Dash
//
//  Created by mac on 14/10/28.
//  Copyright (c) 2014年 TenPercent. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var HighestScore: Int = 0
    let HighestLabel = SKLabelNode(fontNamed: "Futura")
    let ScoreLabel = SKLabelNode(fontNamed: "Futura")
    
    init(size: CGSize, score: Int) {
        super.init(size: size)
        var randomChance = arc4random() % 8
        switch randomChance {
        case 0: backgroundColor = UIColor.blueColor()
        case 1: backgroundColor = UIColor.grayColor()
        case 2: backgroundColor = UIColor.brownColor()
        case 3: backgroundColor = UIColor.greenColor()
        case 4: backgroundColor = UIColor.orangeColor()
        case 5: backgroundColor = UIColor.purpleColor()
        case 6: backgroundColor = UIColor.yellowColor()
        case 7: backgroundColor = UIColor.magentaColor()
        default: break
        }
        let standardDefaults = NSUserDefaults.standardUserDefaults()
        HighestScore = standardDefaults.integerForKey("HighestScore")
        if HighestScore < score {
            HighestScore = score
            standardDefaults.setInteger(score, forKey: "HighestScore")
            standardDefaults.synchronize()
        }
        HighestLabel.text = "Highest: " + String(HighestScore)
        HighestLabel.fontSize = 30
        HighestLabel.fontColor = UIColor.redColor()
        HighestLabel.position = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.75)
        addChild(HighestLabel)
        ScoreLabel.text = "Final Score: " + String(score)
        ScoreLabel.fontSize = 30
        ScoreLabel.fontColor = UIColor.blackColor()
        ScoreLabel.position = CGPointMake(frame.size.width * 0.5, frame.size.height * 0.5)
        addChild(ScoreLabel)
        let Restart = SKLabelNode(fontNamed: "Futura")
        Restart.text = "Tap to Restart"
        Restart.fontSize = 30
        Restart.position = CGPointMake(frame.size.width / 2, frame.size.height * 0.25)
        addChild(Restart)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        view?.presentScene(GamePlayScene(size: size), transition: SKTransition.fadeWithDuration(0.4))
    }
}