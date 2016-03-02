//
//  GameScene.swift
//  Desgarpy Bird
//
//  Created by 段昊宇 on 16/3/1.
//  Copyright (c) 2016年 Desgard_Duan. All rights reserved.
//

import SpriteKit

enum 图层: CGFloat {
    case 背景
    case 前景
    case 游戏角色
    
}

class GameScene: SKScene {
    

    let k前景地面数 = 2
    let k地面移动速度 = -150
    
    let k重力: CGFloat = -1000.0
    let k上冲速度: CGFloat = 400.0
    var 速度 = CGPoint.zero
    
    let 世界单位 = SKNode()
    var 游戏区域起始点: CGFloat = 0
    var 游戏区域的高度: CGFloat = 0
    var 主角 = SKSpriteNode(imageNamed: "Bird0")
    var 死亡 = false
    
    // 帧率计算
    var 上一次更新时间: NSTimeInterval = 0
    var dt: NSTimeInterval = 0
    
    // 创建音效
    let 叮的音效 = SKAction.playSoundFileNamed("ding.wav", waitForCompletion: false)
    let 拍打的音效 = SKAction.playSoundFileNamed("flapping.wav", waitForCompletion: false)
    let 摔倒的音效 = SKAction.playSoundFileNamed("whack.wav", waitForCompletion: false)
    let 下落的音效 = SKAction.playSoundFileNamed("falling.wav", waitForCompletion: false)
    let 撞击地面的音效 = SKAction.playSoundFileNamed("hitGround.wav", waitForCompletion: false)
    let 砰的音效 = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    let 得分的音效 = SKAction.playSoundFileNamed("coin.wav", waitForCompletion: false)
    
    override func didMoveToView(view: SKView) {
        addChild(世界单位)
        设置背景 ()
        设置前景 ()
        设置主角 ()
        
    }
    
    // MARK: 设置的相关方法
    
    func 设置背景() {
        
        
        let 背景 = SKSpriteNode(imageNamed: "Background")
        背景.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        背景.position = CGPoint(x: size.width / 2, y: size.height)
        背景.zPosition = 图层.背景.rawValue
        世界单位.addChild(背景)
        
        游戏区域起始点 = size.height - 背景.size.height
        游戏区域的高度 = 背景.size.height
    }
    
    func 设置主角 () {
        主角.position = CGPoint(x: size.width * 0.2, y: 游戏区域的高度 * 1.4 + 游戏区域起始点)
        主角.zPosition = 图层.游戏角色.rawValue
        世界单位.addChild(主角)
    }
    
    func 设置前景() {
        for i in 0..<k前景地面数 {
            let 前景 = SKSpriteNode(imageNamed: "Ground")
            前景.anchorPoint = CGPoint(x: 0, y: 1.0)
            前景.position = CGPoint(x: CGFloat(i) * 前景.size.width, y: 游戏区域起始点)
            前景.zPosition = 图层.前景.rawValue
            前景.name = "前景"
            世界单位.addChild(前景)
        }
        
    }
    
    // 游戏流程
    
    func 主角飞一下() {
        if 死亡 == false {
            速度 = CGPoint(x: 0, y: k上冲速度)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 点击屏幕音效
        runAction(拍打的音效)
        
        // 增加上冲速度
        主角飞一下()
    }
   
    // MARK: 更新
    
    override func update(当前时间: CFTimeInterval) {
        if 上一次更新时间 > 0 {
            dt = 当前时间 - 上一次更新时间
        } else {
            dt = 0
        }
        上一次更新时间 = 当前时间
        
        更新主角 ()
        更新前景 ()
    }
    
    func 更新主角() {
        let 加速度 = CGPoint(x: 0, y: k重力)
        速度 = CGPoint(x: 加速度.x * CGFloat(dt) + 速度.x, y: 加速度.y * CGFloat(dt)  + 速度.y)
        主角.position = CGPoint(x: 主角.position.x + 速度.x * CGFloat(dt), y: 主角.position.y + 速度.y * CGFloat(dt))
        
        // 检测是否撞击地面
        if 主角.position.y - 主角.size.height / 2 < 游戏区域起始点 {
            主角.position = CGPoint (x: 主角.position.x, y: 游戏区域起始点 + 主角.size.height / 2.0)
            if 死亡 == false {
                let pos = CGPoint(x: 主角.position.x, y: 游戏区域起始点 + 主角.size.height / 2.0);
                let zpos = 主角.zPosition
                主角.removeFromParent()
                主角 = SKSpriteNode(imageNamed: "Bird0_dead")
                主角.position = pos;
                主角.zPosition = zpos;
                世界单位.addChild(主角)
                死亡 = true
                
                // 增加扑街音效
                runAction(摔倒的音效)
            }
        }
    }
    
    func 更新前景 () {
        if 死亡 == false {
            世界单位.enumerateChildNodesWithName("前景", usingBlock: {
                匹配单位, _ in
                if let 前景 = 匹配单位 as? SKSpriteNode {
                    let 地面移动速度 = CGPoint(x: self.k地面移动速度, y: 0)
                    前景.position = CGPoint(x: 前景.position.x + 地面移动速度.x * CGFloat(self.dt), y: 前景.position.y + 地面移动速度.y * CGFloat(self.dt))
                    
                    if 前景.position.x < -前景.size.width {
                        前景.position = CGPoint(x: 前景.position.x + 前景.size.width * CGFloat (self.k前景地面数), y: 前景.position.y)
                    }
                }
            })
        }
    }
}

