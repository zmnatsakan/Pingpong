//
//  FinishScene.swift
//  PingPong
//
//  Created by  admin on 03.11.2023.
//

import SpriteKit
import SwiftUI

extension GameScene {
    func createFinishScreen(isWin: Bool, coinAmount: Int = 0) {
        createBackground()
        createLabel(isWin)
        createHomeButton()
        createLevelLabel()
        
        if isWin {
            levelNumber += 1
            completed[levelNumber] = true
            createNextButton()
            createInfo(coinAmount: coinAmount)
        } else {
            createRestartButton()
        }
    }
    
    private func createInfo(coinAmount: Int) {
        let texture = SKTexture(imageNamed: "gradients/yellow")
        
        let textureSize = texture.size()
        let labelSize = CGSize(width: size.width,
                               height: size.width * textureSize.height /
                               textureSize.width)
        
        let levelBackground = SKSpriteNode(texture: texture)
        levelBackground.position = CGPoint(x: center.x, y: center.y - 100)
        levelBackground.size = labelSize
        
        addChild(levelBackground)
        
        let label = SKLabelNode(text: "+" + String(coinAmount))
        label.fontName = "HalvarBreit-Blk"
        label.position = CGPoint(x: center.x, y: center.y - 110)
        
        let icon = SKSpriteNode(imageNamed: "icons/coin")
        icon.size = CGSize(width: 30, height: 30)
        icon.position = CGPoint(x: label.position.x + label.frame.width / 2 + 30, y: center.y - 100)
        
        addChild(label)
        addChild(icon)
    }
    
    private func createLevelLabel() {
        let texture = SKTexture(imageNamed: "gradients/red")
        
        let textureSize = texture.size()
        let labelSize = CGSize(width: size.width,
                               height: size.width * textureSize.height /
                               textureSize.width)
        
        let levelBackground = SKSpriteNode(texture: texture)
        levelBackground.position = CGPoint(x: center.x, y: center.y + 100)
        levelBackground.size = labelSize
        
        addChild(levelBackground)
        
        let label = SKLabelNode(text: "Level " + String(levelNumber + 1))
        label.fontName = "HalvarBreit-Blk"
        label.position = CGPoint(x: center.x, y: center.y + 90)
        addChild(label)
    }
    
    private func createBackground() {
        let background = SKSpriteNode(color: UIColor(red: 0.1, green: 0.14, blue: 0.18, alpha: 1), size: size)
        background.position = center
        addChild(background)
    }
    
    private func createLabel(_ isWin: Bool) {
        let texture = SKTexture(imageNamed: isWin ? "win" : "lose")
        let label = SKSpriteNode(texture: texture)
        label.position = center
        addChild(label)
    }
    
    private func createHomeButton() {
        let texture = SKTexture(imageNamed: "buttons/home")
        let textureSize = texture.size()
        let button = SKSpriteNode(texture: texture)
        button.size = CGSize(width: size.width * 0.8,
                             height: size.width * textureSize.height /
                             textureSize.width * 0.8)
        button.position = CGPoint(x: center.x, y: textureSize.height + 30)
        button.name = "home"
        addChild(button)
    }
    
    private func createNextButton() {
        let texture = SKTexture(imageNamed: "buttons/next")
        let textureSize = texture.size()
        let button = SKSpriteNode(texture: texture)
        button.size = CGSize(width: size.width * 0.8,
                             height: size.width * textureSize.height /
                             textureSize.width * 0.8)
        button.position = CGPoint(x: center.x, y: textureSize.height / 2 + 20)
        button.name = "next"
        addChild(button)
    }
    
    private func createRestartButton() {
        let texture = SKTexture(imageNamed: "buttons/restart")
        let textureSize = texture.size()
        let button = SKSpriteNode(texture: texture)
        button.size = CGSize(width: size.width * 0.8,
                             height: size.width * textureSize.height /
                             textureSize.width * 0.8)
        button.position = CGPoint(x: center.x, y: textureSize.height / 2 + 20)
        button.name = "restart"
        addChild(button)
    }
}

//#Preview(body: {
//    SpriteView(scene: FinishScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)))
//        .ignoresSafeArea()
//})
