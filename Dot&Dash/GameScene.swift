//
//  GameScene.swift
//  Dot&Dash
//
//  Created by mac on 14/10/27.
//  Copyright (c) 2014年 TenPercent. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        backgroundColor = SKColor(red: 0, green: 161/255, blue: 233/255, alpha: 1)
        let Name = SKLabelNode(fontNamed: "Futura")
        Name.text = "Dot&Dash"
        Name.fontSize = 50
        Name.position = CGPointMake(frame.size.width/2, frame.size.height*0.75)
        addChild(Name)
        let Start = SKLabelNode(fontNamed: "Futura")
        Start.text = "Tap to Start"
        Start.fontSize = 30
        Start.position = CGPointMake(frame.size.width/2, frame.size.height*0.25)
        addChild(Start)
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view?.presentScene(GamePlayScene(size: size), transition: SKTransition.fadeWithDuration(0.4))
    }
}