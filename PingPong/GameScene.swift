//
//  GameScene.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SpriteKit
import SwiftUI

final class GameScene: SKScene, ObservableObject, SKPhysicsContactDelegate {
    
    // MARK: - Published Properties
    
    @Published var score = (0, 0)
    @Published var isBack: Bool = false
    
    // MARK: - Private Properties
    
    private var player1 = SKSpriteNode()
    private var player2 = SKSpriteNode()
    private var ball = SKSpriteNode()
    private var obstacle = SKSpriteNode()
    private var button = SKSpriteNode()
    
    private let images = ["apple", "apple-core", "banana", "watermelon", "avocado"]
    
    private let ballCategory: UInt32 = 1
    private let detectorCategory: UInt32 = 2
    private let playerCategory: UInt32 = 4
    private let wallCategory: UInt32 = 8
    
    private var timerNode = SKLabelNode()
    private var hitCountNode = SKLabelNode()
    
    private var detectors = [SKShapeNode]()
    
    var configuration: GameConfiguration?
    
    var center: CGPoint {
        return CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
    
    var timeLeft: Int = 99 {
        didSet {
            timerNode.text = "Time Left: \(timeLeft < 10 ? "0" : "")\(timeLeft)"
        }
    }
    
    var hitCount: Int = 0 {
        didSet {
            hitCountNode.text = "Hits: \(hitCount < 10 ? "0" : "")\(hitCount)"
        }
    }
    
    // MARK: - Initialization
    
    init(size: CGSize, configuration: GameConfiguration) {
        self.configuration = configuration
        super.init(size: size)
        setupObjects()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        setupObjects()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Scene Setup
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(countdown), SKAction.wait(forDuration: 1)])))
    }
    
    // MARK: - Touch Handling
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if button.contains(touch.location(in: self)) {
            isBack.toggle()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !touches.isEmpty else { return }
        for touch in touches {
            let touchLocation = touch.location(in: self)
            let player = touchLocation.y < size.height / 2 ? player1 : player2
            let playerWidth = player1.size.width
            let minX = playerWidth / 2 + 5
            let maxX = size.width - playerWidth / 2 - 5
            
            guard minX < touchLocation.x && touchLocation.x < maxX else { return }
            player.position.x = touchLocation.x
        }
    }
    
    // MARK: - Update Methods
    
    override func didFinishUpdate() {
        let player1Win = ball.position.y > player2.position.y + 50
        let player2Win = ball.position.y < player1.position.y - 50
        
        if player1Win || player2Win {
            ball.run(SKAction.fadeOut(withDuration: 0.5))
            ball.removeFromParent()
            createBall(at: CGPoint(x: size.width / 2, y: size.height / 2))
            addChild(ball)
            
            if player1Win {
                score.0 += 1
            } else {
                score.1 += 1
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let halfPaddleWidth = player2.size.width / 2
        let targetX = ball.position.x.clamped(to: halfPaddleWidth...(size.width - halfPaddleWidth))
        
        let deltaX = targetX - player2.position.x
        let timeToReachTarget = abs(deltaX) / 350
        
        let moveAction = SKAction.moveTo(x: targetX, duration: TimeInterval(timeToReachTarget))
        player2.run(moveAction)
    }
    
    // MARK: - Physics Contact Delegate
    
    var isBoost = false
    var isHit = false
    
    func didBegin(_ contact: SKPhysicsContact) {
        handleContact(contact)
    }
    
    // MARK: - Game Restart
    
    func reloadScene() {
        score = (0, 0)
        setupObjects()
    }
    
    private func countdown() {
        timeLeft -= 1
        if timeLeft <= 0 {
            reloadScene()
        }
    }
    
    // MARK: - Object Setup
    
    private func setupObjects() {
        removeAllChildren()
        
        physicsWorld.gravity = .zero
        
        createPlayers()
        
        // Create ball always
        createBall(at: CGPoint(x: player1.position.x, y: size.height / 2 - 200))
        
        if let config = configuration {
            if let time = config.time {
                createTimer(seconds: time)
            }
            
            if config.hasObstacles {
                createObstacles()
            }
            
            if config.hasBoostFields {
                createBoostFields()
            }
            
            if let hitTarget = config.hitTarget {
                createHitCount(target: hitTarget)
            }
        }
        
        createPlayers()
        createWalls()
        
        // Setting up button
        button = SKSpriteNode(texture: SKTexture(imageNamed: "back"), size: CGSize(width: 50, height: 50))
        button.position = CGPoint(x: 60, y: size.height - 60)
        
        addChild(player1)
        addChild(player2)
        addChild(ball)
        addChild(button)
    }
    
    
    private func createObstacles() {
        createObstacle(at: center, offset: 100)
    }
    
    private func createBoostFields() {
        createDetector(named: "boost", at: CGPoint(x: size.width / 2, y: size.height / 2), size: CGSize(width: 100, height: 100))
    }
    
    private func createHitCount(target: Int) {
        hitCountNode.position = CGPoint(x: frame.width, y: frame.height - 100)
        hitCount = 0
        hitCountNode.fontColor = .white
        hitCountNode.horizontalAlignmentMode = .right
        addChild(hitCountNode)
    }
    
    private func createTimer(seconds: Int) {
        timerNode.position = CGPoint(x: frame.width, y: frame.height - 50)
        timeLeft = seconds
        timerNode.fontColor = .white
        timerNode.horizontalAlignmentMode = .right
        addChild(timerNode)
    }
    
    private func createObstacle(at position: CGPoint, offset: CGFloat) {
        let obstacle = SKShapeNode(rectOf: CGSize(width: 20, height: 50))
        let startPosition = CGPoint(x: position.x - offset, y: position.y)
        let endPosition = CGPoint(x: position.x + offset, y: position.y)
        
        obstacle.position = startPosition
        obstacle.fillColor = .red
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 50)).ideal().manualMovement()
        let sequence = SKAction.sequence([SKAction.move(to: endPosition, duration: 1), SKAction.move(to: startPosition, duration: 1)])
        let animation = SKAction.repeatForever(sequence)
        obstacle.run(animation)
        addChild(obstacle)
    }
    
    private func createDetector(named name: String, at position: CGPoint, size: CGSize) {
        let detector = SKShapeNode(rectOf: size)
        detector.physicsBody = SKPhysicsBody(rectangleOf: size).ideal().manualMovement()
        detector.position = position
        detector.strokeColor = .green
        detector.physicsBody?.categoryBitMask = detectorCategory
        detector.physicsBody?.contactTestBitMask = ballCategory
        detector.physicsBody?.collisionBitMask = 0
        detector.name = name
        addChild(detector)
    }
    
    private func addWall(at position: CGPoint) {
        let wallSize = CGSize(width: 1, height: size.height)
        let wall = SKShapeNode(rectOf: wallSize)
        wall.physicsBody = SKPhysicsBody(rectangleOf: wallSize).ideal().manualMovement()
        wall.position = position
        wall.strokeColor = .clear
        addChild(wall)
    }
    
    private func createWalls() {
        addWall(at: CGPoint(x: 0, y: size.height / 2))
        addWall(at: CGPoint(x: size.width, y: size.height / 2))
    }
    
    private func createPlayers() {
        player1 = createPlayer(position: CGPoint(x: size.width / 2, y: size.width / 2))
        player2 = createPlayer(position: CGPoint(x: size.width / 2, y: (size.height + size.width) / 2))
        player2.zRotation = .pi
    }
    
    private func createPlayer(position: CGPoint) -> SKSpriteNode {
        let player = SKSpriteNode(imageNamed: "lens")
        player.size = CGSize(width: 100, height: 25)
        player.position = position
        player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "lens"), size: player.size).ideal().manualMovement()
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = ballCategory
        player.physicsBody?.contactTestBitMask = ballCategory
        return player
    }
    
    private func createBall(at position: CGPoint) {
        let size = CGSize(width: 40, height: 40)
        let imageName = images.randomElement() ?? "apple"
        
        let ball = SKSpriteNode(imageNamed: imageName)
        ball.size = size
        ball.position = position
        //        ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageName), size: size).ideal()
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 20).ideal()
        ball.physicsBody?.velocity = CGVector(dx: 20, dy: -250)
        ball.physicsBody?.angularVelocity = 5
        ball.physicsBody?.angularDamping = 1
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = 0
        ball.physicsBody?.collisionBitMask = playerCategory
        ball.name = "ball"
        ball.alpha = 0
        
        let action = SKAction.fadeIn(withDuration: 0.5)
        ball.run(action)
        self.ball = ball
    }
    
    // MARK: - Helper Methods for Object Creation and Handling
    
    private func handleBoost() {
        guard !isBoost else { return }
        
        if let physicsBody = ball.physicsBody {
            physicsBody.velocity += physicsBody.velocity.normalized * 150.0
            isBoost = true
        }
        
        let wait = SKAction.wait(forDuration: 0.2)  // Adjust the duration as needed
        let completion = SKAction.run {
            self.handleBoostEnd()
        }
        let sequence = SKAction.sequence([wait, completion])
        run(sequence, withKey: "boostEndSequence")
    }
    
    private func handleHit() {
        guard !isHit else { return }
        
        hitCount += 1
        isHit = true
        
        let wait = SKAction.wait(forDuration: 0.2)  // Adjust the duration as needed
        let completion = SKAction.run {
            self.handleHitEnd()
        }
        let sequence = SKAction.sequence([wait, completion])
        run(sequence, withKey: "hitEndSequence")
    }
    
    private func handleBoostEnd() {
        if isBoost {
            isBoost = false
        }
    }
    
    private func handleHitEnd() {
        if isHit {
            // Implement any additional behavior here if required.
            isHit = false
        }
    }
    
    func handleContact(_ contact: SKPhysicsContact) {
        switch ContactType(contact: contact) {
        case .ballWithBoost:
            handleBoost()
        case .ballWithPlayer:
            handleHit()
        case .none:
            break
        }
    }
}
