//
//  GameScene.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SpriteKit
import SwiftUI

final class GameScene: SKScene, ObservableObject, SKPhysicsContactDelegate {
    // MARK: - Persisted Properties
    
    @AppStorage("completed") var completed: [Int: Bool] = [:]
    
    // MARK: - Private Properties
    
    private var player1 = SKSpriteNode()
    private var player2 = SKSpriteNode()
    private var ball = SKSpriteNode()
    private var obstacle = SKSpriteNode()
    private var backButton = SKSpriteNode()
    private var nextButton = SKSpriteNode()
    private var retryButton = SKSpriteNode()
    
//    private let images = ["apple", "apple-core", "banana", "watermelon", "avocado"]
    
    private let ballCategory: UInt32 = 1
    private let boostCategory: UInt32 = 2
    private let playerCategory: UInt32 = 4
    private let wallCategory: UInt32 = 8
    private let levelLabel = SKLabelNode()
    private var timerNode = SKLabelNode()
    private var hitCountNode = SKLabelNode()
    private var scoreNodes = (SKLabelNode(), SKLabelNode())
    private var levelNumber = 0
    
    private var detectors = [SKShapeNode]()
    
    private var configuration: GameConfiguration?
    private var backButtonAction: () -> ()
    
    private var center: CGPoint {
        return CGPoint(x: frame.width / 2, y: frame.height / 2)
    }
    
    private var score = (0, 0) {
        didSet {
            scoreNodes.0.text = "\(score.0)"
            if let scoreGoal = configuration?.goalTarget {
                scoreNodes.0.text! += "/\(scoreGoal)"
            }
            scoreNodes.1.text = "\(score.1)"
        }
    }
    
    private var timeLeft: Int = 99 {
        didSet {
            timerNode.text = "Time Left: \(timeLeft < 10 ? "0" : "")\(timeLeft)"
        }
    }
    
    private var hitCount: Int = 0 {
        didSet {
            hitCountNode.text = "Hits: \(hitCount)/\(configuration?.hitTarget ?? 0)"
        }
    }
    
    // MARK: - Initialization
    
    init(size: CGSize, levelNumber: Int, isFreePlayMode: Bool = false, backButtonAction: @escaping () -> () = {}) {
        self.backButtonAction = backButtonAction
        self.levelNumber = levelNumber
        super.init(size: size)
        setupObjects(isFreePlay: isFreePlayMode)
        print("freeplay:", isFreePlayMode)
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
        let currentTouch = touch.location(in: self)
        if backButton.contains(currentTouch) {
            backButtonAction()
        } else if nextButton.contains(currentTouch) {
            levelNumber += 1
            reloadScene()
        } else if retryButton.contains(currentTouch) {
            reloadScene()
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
            
            if player1Win {
                score.0 += 1
                checkFinishGame()
                createBall(at: CGPoint(x: player1.position.x, y: player1.position.y + 10),
                           speedMultiplier: (configuration?.ballSpeedMultiplier ?? 1))
                addChild(ball)
                HapticManager.shared.heavyFeedback()
            } else {
                score.1 += 1
                createBall(at: CGPoint(x: player2.position.x, y: player2.position.y - 10),
                           speedMultiplier: -(configuration?.ballSpeedMultiplier ?? 1))
                addChild(ball)
                HapticManager.shared.heavyFeedback()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let halfPaddleWidth = player2.size.width / 2
        let targetX = ball.position.x.clamped(to: halfPaddleWidth...(size.width - halfPaddleWidth))
        
        let deltaX = targetX - player2.position.x
        let timeToReachTarget = abs(deltaX) / (350 * (configuration?.computerSpeedMultiplier ?? 1))
        
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
            checkFinishGame()
        }
    }
    
    // MARK: - Object Setup
    
    private func setupObjects(isFreePlay: Bool = false) {
        removeAllChildren()
        
        configuration = LevelConfig.levels[levelNumber % LevelConfig.levels.count]
        if isFreePlay {
            configuration?.makeFreePlay()
        }
        physicsWorld.gravity = .zero
        
        createPlayers()
        createScoreLabels()
        
        
        // Create ball always
        createBall(at: CGPoint(x: player1.position.x, y: size.height / 2 - 200),
                   speedMultiplier: (configuration?.ballSpeedMultiplier ?? 1))
        
        
        
        if let config = configuration {
            if !config.isFreePlay {
                if let time = config.time { createTimer(seconds: time) }
                if let hitTarget = config.hitTarget { createHitCount(target: hitTarget) }
            }
            
            if !config.obstacles.isEmpty { createObstacles(config.obstacles) }
            if !config.boosts.isEmpty { createBoostFields(config.boosts) }
        }
        
        createWalls()
        createBackButton()
        createLevelLabel()
        
        
        addChild(player1)
        addChild(player2)
        addChild(ball)
        
        score = (0, 0)
    }
    
    private func createLevelLabel() {
        levelLabel.position = CGPoint(x: center.x, y: 0)
        levelLabel.text = "Level \(levelNumber + 1)"
        addChild(levelLabel)
    }
    
    private func createScoreLabels() {
        scoreNodes.0.position = CGPoint(x: center.x, y: (player1.position.y) / 2)
        scoreNodes.0.fontColor = .white
        addChild(scoreNodes.0)
        scoreNodes.1.position = CGPoint(x: center.x, y: (frame.height + player2.position.y) / 2)
        scoreNodes.1.fontColor = .white
        addChild(scoreNodes.1)
    }
    
    private func createSemiTransparentBackground() -> SKSpriteNode {
        ball.removeFromParent()
        let background = SKSpriteNode(color: SKColor.black, size: self.size)
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 10 // Ensure it's rendered above other nodes
        background.alpha = 0  // Start invisible for the fade in animation
        return background
    }
    
    private func showWinScreen() {
        let background = createSemiTransparentBackground()
        addChild(background)
        
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        background.run(fadeIn)
        
        let winLabel = SKLabelNode(text: "You Win!")
        winLabel.fontSize = 40
        winLabel.fontColor = SKColor.green
        winLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 20)
        winLabel.alpha = 0
        winLabel.zPosition = 11
        addChild(winLabel)
        winLabel.run(fadeIn)
        
        let nextButton = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 150, height: 50))
        nextButton.name = "nextButton"
        nextButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 50)
        nextButton.alpha = 0
        nextButton.zPosition = 11
        addChild(nextButton)
        nextButton.run(fadeIn)
        self.nextButton = nextButton
        
        let buttonText = SKLabelNode(text: "Next")
        buttonText.fontSize = 20
        buttonText.fontColor = SKColor.white
        buttonText.position = CGPoint.zero
        buttonText.alpha = 0
        buttonText.zPosition = 12
        nextButton.addChild(buttonText)
        buttonText.run(fadeIn)
        HapticManager.shared.successFeedback()
        completed[levelNumber] = true
    }
    
    func showLoseScreen() {
        // Create and add the semi-transparent background
        let background = createSemiTransparentBackground()
        addChild(background)
        
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        background.run(fadeIn)
        
        // Set up the "You Lose!" label with fade-in animation
        let loseLabel = SKLabelNode(text: "You Lose!")
        loseLabel.fontSize = 40
        loseLabel.fontColor = SKColor.red
        loseLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2 + 20)
        loseLabel.alpha = 0  // Start invisible for the fade in animation
        loseLabel.zPosition = 11
        addChild(loseLabel)
        loseLabel.run(fadeIn)
        
        // Set up the "Retry" button with fade-in animation
        let retryButton = SKSpriteNode(color: SKColor.orange, size: CGSize(width: 150, height: 50))
        retryButton.name = "retryButton"
        retryButton.position = CGPoint(x: self.size.width/2, y: self.size.height/2 - 50)
        retryButton.alpha = 0  // Start invisible for the fade in animation
        retryButton.zPosition = 11
        addChild(retryButton)
        retryButton.run(fadeIn)
        self.retryButton = retryButton
        
        // Add the text "Retry" to the button and run fade-in animation
        let buttonText = SKLabelNode(text: "Retry")
        buttonText.fontSize = 20
        buttonText.fontColor = SKColor.white
        buttonText.position = CGPoint.zero
        buttonText.alpha = 0  // Start invisible for the fade in animation
        buttonText.zPosition = 12
        retryButton.addChild(buttonText)
        buttonText.run(fadeIn)
        HapticManager.shared.errorFeedback()
    }

    
    private func createBackButton() {
        backButton = SKSpriteNode(texture: SKTexture(imageNamed: "back"), size: CGSize(width: 50, height: 50))
        backButton.position = CGPoint(x: 60, y: size.height - 60)
        addChild(backButton)
    }
    
    private func createObstacles(_ obstacles: [Obstacle]) {
        for obstacle in obstacles {
            createObstacle(type: obstacle.type,
                           at: obstacle.position,
                           offset: obstacle.offset,
                           size: obstacle.size)
        }
    }
    
    private func createBoostFields(_ boosts: [Boost]) {
        for boost in boosts {
            createBoostField(type: boost.type,
                             at: boost.position,
                             size: boost.size)
        }
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
    
    private func createObstacle(type: ObstacleType = .horizontal, at positionName: Position, offset: CGFloat, size: CGSize) {
        
        let position = getPosition(positionName, size: size)
        let obstacle = SKShapeNode(rectOf: size)
        
        let xOffset = type == .horizontal ? offset : 0
        let yOffset = type == .vertical ? offset : 0
        
        let startPosition = CGPoint(x: position.x - xOffset, y: position.y - yOffset)
        let endPosition = CGPoint(x: position.x + xOffset, y: position.y + yOffset)
        
        obstacle.position = startPosition
        obstacle.fillColor = .red
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 50)).ideal().manualMovement()
        let sequence = SKAction.sequence([SKAction.move(to: endPosition, duration: 1), SKAction.move(to: startPosition, duration: 1)])
        let animation = SKAction.repeatForever(sequence)
        obstacle.run(animation)
        addChild(obstacle)
    }
    
    private func createBoostField(type: BoostType = .boost, at positionName: Position, size: CGSize) {
        let position = getPosition(positionName, size: size)
        let boost = SKShapeNode(rectOf: size)
        boost.physicsBody = SKPhysicsBody(rectangleOf: size).ideal().manualMovement()
        boost.position = position
        boost.strokeColor = .green
        boost.physicsBody?.categoryBitMask = boostCategory
        boost.physicsBody?.contactTestBitMask = ballCategory
        boost.physicsBody?.collisionBitMask = 0
        boost.name = "boost"
        addChild(boost)
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
        let imageName = configuration?.playerTexture.rawValue ?? "lens"
        let player = SKSpriteNode(imageNamed: imageName)
        player.size = CGSize(width: 100, height: 25)
        player.position = position
        player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageName),
                                           size: player.size).ideal().manualMovement()
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = ballCategory
        player.physicsBody?.contactTestBitMask = ballCategory
        return player
    }
    
    private func createBall(at position: CGPoint, speedMultiplier: CGFloat = 1) {
        let size = CGSize(width: 40, height: 40)
        let imageName = configuration?.ballTexture.rawValue ?? "apple"
        
        let ball = SKSpriteNode(imageNamed: imageName)
        ball.size = size
        ball.position = position
        //        ball.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageName), size: size).ideal()
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 20).ideal()
        ball.physicsBody?.velocity = CGVector(dx: 20, dy: -250) * speedMultiplier
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
    
    private func checkFinishGame() {
        guard !(configuration?.isFreePlay ?? false) else { return }
        if timeLeft <= 0 || configuration?.time == nil {
            if  configuration?.hitTarget == nil || configuration!.hitTarget! <= hitCount {
                if (configuration?.goalTarget == nil && score.0 > score.1) || 
                    (configuration?.goalTarget ?? 0 <= score.0 && score.0 > score.1) {
                    showWinScreen()
                } else {
                    showLoseScreen()
                }
            } else {
                showLoseScreen()
            }
        }
    }
    
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
        HapticManager.shared.lightFeedback()
        checkFinishGame()
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
    
    private func handleContact(_ contact: SKPhysicsContact) {
        switch ContactType(contact: contact) {
        case .ballWithBoost:
            handleBoost()
        case .ballWithPlayer:
            handleHit()
        case .none:
            break
        }
    }
    
    private func getPosition(_ name: Position, size: CGSize) -> CGPoint {
        switch name {
        case .center:
            return center
        case .left:
            return CGPoint(x: size.width / 2,
                           y: center.y)
        case .right:
            return CGPoint(x: frame.width - size.width / 2,
                           y: center.y)
        case .top:
            return CGPoint(x: center.x,
                           y: player2.position.y - size.height / 2)
        case .bottom:
            return CGPoint(x: center.x,
                           y: player1.position.y + size.height / 2)
        case .topLeft:
            return CGPoint(x: size.width / 2,
                           y: player2.position.y - size.height / 2)
        case .topRight:
            return CGPoint(x: frame.width - size.width / 2,
                           y: player2.position.y - size.height / 2)
        case .bottomLeft:
            return CGPoint(x: size.width / 2,
                           y: player1.position.y + size.height / 2)
        case .bottomRight:
            return CGPoint(x: frame.width - size.width / 2,
                           y: player1.position.y + size.height / 2)
        }
    }
}
