//
//  GameScene.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SpriteKit
import SwiftUI

final class GameScene: SKScene, ObservableObject, SKPhysicsContactDelegate {
    @Published var score = (0, 0)
    @Published var isBack: Bool = false
    private var player1 = SKSpriteNode()
    private var player2 = SKSpriteNode()
    private var ball = SKSpriteNode()
    private var obstacle = SKSpriteNode()
    private var button = SKSpriteNode()
    
    private let images = ["apple", "apple-core", "banana", "watermelon", "avocado"]
    
    private let ballCategory  : UInt32 = 1
    private let detectorCategory : UInt32 = 2
    private let playerCategory : UInt32 = 3
    
    private var detectors = [SKShapeNode]()
    
    override init(size: CGSize) {
        self.isBack = false
        super.init(size: size)
        setupObjects()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        // Check if the location of the touch is within the button's bounds
        if button.contains(location) {
            isBack.toggle()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !touches.isEmpty else { return }
        
        for touch in touches {
            let isTouchBelowCenter = touch.location(in: self).y < size.height / 2
            let player = isTouchBelowCenter ? player1 : player2
            
            let touchLocation = touch.location(in: self)
            let playerWidth = player1.size.width
            let minX = playerWidth / 2 + 5
            let maxX = size.width - playerWidth / 2 - 5
            
            guard minX < touchLocation.x && touchLocation.x < maxX else { return }
            
            player.position.x = touchLocation.x
        }
    }
    
    override func didFinishUpdate() {
        let player1Win = ball.position.y > player2.position.y + 50
        let player2Win = ball.position.y < player1.position.y - 50
        if player1Win || player2Win {
            ball.run(SKAction.fadeOut(withDuration: 0.5))
            ball.removeFromParent()
            createBall(position: CGPoint(x: size.width / 2, y: size.height / 2))
            addChild(ball)
            if player1Win {
                score.0 += 1
            } else {
                score.1 += 1
            }
        }
    }
    
    //    func didBegin(_ contact: SKPhysicsContact) {
    //        if contact.bodyA.node?.name == "detector1" && contact.bodyB.node?.name == "ball" {
    //            score.0 += 1
    //            setupObjects()
    //        } else if contact.bodyA.node?.name == "detector2" && contact.bodyB.node?.name == "ball" {
    //            score.1 += 1
    //            setupObjects()
    //        }
    //    }
    
    func reloadScene() {
        score = (0, 0)
        setupObjects()
    }
    
    //MARK: - Setup objects
    private func setupObjects() {
        removeAllChildren()
        self.createPlayers()
        self.createBall(position: CGPoint(x: size.width / 2, y: size.height / 2))
        self.button = SKSpriteNode(texture: SKTexture(imageNamed: "back"),
                                   size: CGSize(width: 50, height: 50))
        
        createWalls()
        //        createDetectors()
        createObstacle(at: CGPoint(x: size.width / 2, y: size.height / 2), offset: size.width / 2 - 100)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        addChild(player1)
        addChild(player2)
        addChild(ball)
        
        // Button
        button.position = CGPoint(x: 60, y: size.height - 60)
        addChild(button)
    }
    
    private func createObstacle(at position: CGPoint, offset: CGFloat) {
        let obstacle = SKShapeNode(rectOf: CGSize(width: 20, height: 50))
        let startPosition = CGPoint(x: position.x - offset, y: position.y)
        let endPosition = CGPoint(x: position.x + offset, y: position.y)
        
        obstacle.position = startPosition
        obstacle.fillColor = .red
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 50)).ideal().manualMovement()
        let sequence = SKAction.sequence([SKAction.move(to: endPosition, duration: 1),
                                          SKAction.move(to: startPosition, duration: 1)])
        let animation = SKAction.repeatForever(sequence)
        obstacle.run(animation)
        addChild(obstacle)
    }
    
    private func createDetectors() {
        createDetector("detector1", at: CGPoint(x: size.width / 2, y: -50))
        createDetector("detector2", at: CGPoint(x: size.width / 2, y: size.width + 50))
        for detector in detectors {
            addChild(detector)
        }
    }
    
    private func createDetector(_ name: String, at position: CGPoint) {
        let detectorSize = CGSize(width: size.width + 100, height: 5)
        let detector = SKShapeNode(rectOf: detectorSize)
        detector.physicsBody = SKPhysicsBody(rectangleOf: detectorSize)
            .ideal()
            .manualMovement()
        detector.position = position
        detector.strokeColor = .clear
        detector.physicsBody?.categoryBitMask = detectorCategory
        detector.physicsBody?.contactTestBitMask = detectorCategory
        detector.physicsBody?.collisionBitMask = 0
        detector.name = name
        detectors.append(detector)
    }
    
    private func addWall(at position: CGPoint) {
        let wallSize = CGSize(width: 1, height: size.height)
        let wall = SKShapeNode(rectOf: wallSize)
        wall.physicsBody = SKPhysicsBody(rectangleOf: wallSize)
            .ideal()
            .manualMovement()
        wall.position = position
        wall.strokeColor = .clear
        addChild(wall)
    }
    
    private func createWalls() {
        addWall(at: CGPoint(x: 0, y: size.height / 2))
        addWall(at: CGPoint(x: size.width, y: size.height / 2))
    }
    
    private func createPlayers() {
        self.player1 = createPlayer(position: CGPoint(x: size.width / 2, y: size.width / 2))
        self.player2 = createPlayer(position: CGPoint(x: size.width / 2,
                                                      y: (size.height + size.width) / 2))
        player2.zRotation = .pi
    }
    
    private func createPlayer(position: CGPoint) -> SKSpriteNode {
        //        let player = SKSpriteNode(color: .white, size: CGSize(width: 100, height: 10))
        let player = SKSpriteNode(imageNamed: "lens")
        player.size = CGSize(width: 100, height: 25)
        
        player.position = position
        //        player.physicsBody = SKPhysicsBody(rectangleOf: player.size).ideal().manualMovement()
        player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "lens"), size: player.size).ideal().manualMovement()
        return player
    }
    
    private func createBall(position: CGPoint) {
        let size = CGSize(width: 40, height: 40)
        let imageName = images.randomElement()
        
        let ball = SKSpriteNode(imageNamed: imageName ?? "apple")
        ball.size = size
        ball.position = position
        ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageName ?? "apple"), size: size)
            .ideal()
        ball.physicsBody?.velocity = CGVector(dx: 200, dy: 100)
        ball.physicsBody?.angularVelocity = 10
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = detectorCategory
        ball.name = "ball"
        
        ball.alpha = 0
        
        let action = SKAction.fadeIn(withDuration: 0.5)
        ball.run(action)
        self.ball = ball
    }
}
