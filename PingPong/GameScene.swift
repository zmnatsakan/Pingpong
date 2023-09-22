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
    private var ball = SKShapeNode()
    private var button = SKShapeNode()
    
    private let ballCategory  : UInt32 = 0x1 << 1
    private let detectorCategory : UInt32 = 0x1 << 2
    
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
    
//    override func didFinishUpdate() {
//        if ball.position.y > size.height {
//            score.0 += 1
//            setupObjects()
//        } else if ball.position.y < 0 {
//            score.1 += 1
//            setupObjects()
//        }
//    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        printContent("contact")
//        if contact.bodyA.node?.name == "detector1" && contact.bodyB.node?.name == "ball" {
//            score.0 += 1
//            setupObjects()
//        } else if contact.bodyA.node?.name == "detector2" && contact.bodyB.node?.name == "ball" {
//            score.1 += 1
//            setupObjects()
//        }
    }
    
    
    //MARK: - Setup objects
    private func setupObjects() {
        removeAllChildren()
        self.createPlayers()
        self.createBall(position: CGPoint(x: size.width / 2, y: size.height / 2))
        self.button = SKShapeNode(rectOf: CGSize(width: 20, height: 20))
        
        createWalls()
        createDetectors()
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        addChild(player1)
        addChild(player2)
        addChild(ball)
        
        // Button
        button.position = CGPoint(x: 20, y: size.height - 20)
        button.fillColor = .green
        addChild(button)
    }
    
    private func createDetectors() {
        createDetector("detector1", at: CGPoint(x: size.width / 2, y: -20))
        createDetector("detector2", at: CGPoint(x: size.width / 2, y: size.height + 20))
        for detector in detectors {
            addChild(detector)
        }
    }
    
    private func createDetector(_ name: String, at position: CGPoint) {
        let detectorSize = CGSize(width: size.width, height: 2)
        let detector = SKShapeNode(rectOf: detectorSize)
        detector.physicsBody = SKPhysicsBody(rectangleOf: detectorSize)
            //.ideal()
            .manualMovement()
        detector.position = position
        detector.strokeColor = .clear
        detector.physicsBody?.categoryBitMask = detectorCategory
        // set contactTestBitMask = 0 to prevent crash -vvv-
        detector.physicsBody?.contactTestBitMask = detectorCategory
        detector.physicsBody?.collisionBitMask = ballCategory
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
        let playerSize = CGSize(width: 100, height: 10)
        
        self.player1 = createPlayer(position: CGPoint(x: size.width / 2, y: playerSize.height))
        self.player2 = createPlayer(position: CGPoint(x: size.width / 2, y: size.height - playerSize.height))
    }

    private func createPlayer(position: CGPoint) -> SKSpriteNode {
        let player = SKSpriteNode(color: .white, size: CGSize(width: 100, height: 10))
        
        player.position = position
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size).ideal().manualMovement()
        
//        let path = CGPath(ellipseIn: CGRect(x: -50, y: -5, width: 100, height: 10), transform: nil)
//        player.physicsBody = SKPhysicsBody(polygonFrom: path).ideal().manualMovement()
        return player
    }

    private func createBall(position: CGPoint) {
        let ball = SKShapeNode(circleOfRadius: 10.0)
        ball.position = position
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 10.0).ideal()
        ball.physicsBody?.velocity = CGVector(dx: 0, dy: 100)
        ball.fillColor = .white
        ball.physicsBody?.categoryBitMask = ballCategory
        // set contactTestBitMask = 0 to prevent crash -vvv-
        ball.physicsBody?.contactTestBitMask = detectorCategory
        ball.physicsBody?.collisionBitMask = detectorCategory
        ball.name = "ball"
        self.ball = ball
    }
}
