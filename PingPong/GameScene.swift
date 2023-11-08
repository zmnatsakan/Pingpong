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
    @AppStorage("currentLevel") var levelNumber = 0
    @AppStorage("activeBallTexture") var activeBallTexture = BallTexture.apple
    @AppStorage("activeBackgroundTexture") var activeBackgroundTexture = BackgroundTexture.blue
    @AppStorage("activePlatformTexture") var activePlayerTexture = PlatformTexture.stick
    
    
    @EnvironmentObject var observer: RoutesObserver
    
    // MARK: - Private Properties
    
    private var player1 = SKSpriteNode()
    private var player2 = SKSpriteNode()
    private var ball = SKSpriteNode()
    private var obstacle = SKSpriteNode()
    private var backButton = SKSpriteNode()
    private var nextButton = SKSpriteNode()
    private var retryButton = SKSpriteNode()

    private let ballCategory: UInt32 = 1
    private let boostCategory: UInt32 = 2
    private let playerCategory: UInt32 = 4
    private let wallCategory: UInt32 = 8
    private let levelLabel = SKLabelNode()
    private var timerNode = SKLabelNode()
    private var hitCountNode = SKLabelNode()
    private var scoreNodes = (SKLabelNode(), SKLabelNode())
    
    private var isFinished = false
    
    private var detectors = [SKShapeNode]()
    
    private var configuration: GameConfiguration?
    
    private var storeSystem = StoreSystem()
//    private var finishScene: FinishScene?
    private var backButtonAction: () -> ()
    
    var center: CGPoint {
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
            timerNode.text = "\(timeLeft < 10 ? "0" : "")\(timeLeft)"
        }
    }
    
    private var hitCount: Int = 0 {
        didSet {
            hitCountNode.text = "\(hitCount)/\(configuration?.hitTarget ?? 0)"
        }
    }
    
    // MARK: - Initialization
    
    init(size: CGSize, levelNumber: Int, isFreePlayMode: Bool = false, backButtonAction: @escaping () -> () = {}) {
        self.backButtonAction = backButtonAction
        self.levelNumber = levelNumber
        super.init(size: size)
        setupObjects(isFreePlay: isFreePlayMode)
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
        }
        
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        if touchedNode.name == "next" {
            reloadScene()
        } else if touchedNode.name == "restart" {
            reloadScene()
        } else if touchedNode.name == "home" {
            backButtonAction()
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
                createBall(at: CGPoint(x: player1.position.x, y: player1.position.y + 40),
                           speedMultiplier: (configuration?.ballSpeedMultiplier ?? 1))
                addChild(ball)
                HapticManager.shared.heavyFeedback()
            } else {
                score.1 += 1
                createBall(at: CGPoint(x: player2.position.x, y: player2.position.y - 40),
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
        
        if configuration?.platformTexture == .red || configuration?.platformTexture == .green {
            player2.zRotation = .pi - (center.x - player2.position.x) / size.width * .pi / 2
        }
        if activePlayerTexture == .red || activePlayerTexture == .green {
            player1.zRotation = (center.x - player1.position.x) / size.width * .pi / 2
        }
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
        isFinished = false
    }
    
    private func countdown() {
        timeLeft -= 1
        if timeLeft <= 0 {
            checkFinishGame()
        }
    }
    
    // MARK: - Object Setup
    
    private func setupObjects(isFreePlay: Bool = false) {
        self.removeAllChildren()
        
        configuration = LevelConfig.levels[levelNumber % LevelConfig.levels.count]
        if isFreePlay {
            configuration?.makeFreePlay()
        }
        physicsWorld.gravity = .zero
        
        createPlayers()
        createScoreLabels()
        createBackground()
        
        retryButton = SKSpriteNode()
        nextButton = SKSpriteNode()
        
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
    
    private func createBackground() {
        let bgColor = SKSpriteNode(color: UIColor(red: 0.1, green: 0.14, blue: 0.18, alpha: 1), size: size)
        bgColor.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        bgColor.zPosition = -20
        addChild(bgColor)
        let texture = SKTexture(imageNamed: activeBackgroundTexture.rawValue)
        let textureSize = CGSize(width: size.width, height: size.width * texture.size().height / texture.size().width)
        let background = SKSpriteNode(texture: texture, size: textureSize)
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -10 // Ensure it's rendered below other nodes
        background.alpha = 0.5
        addChild(background)
    }
    
    private func createLevelLabel() {
        let gradient = SKSpriteNode(texture: SKTexture(imageNamed: "gradients/sideGreen"))
        gradient.size = CGSize(width: size.width / 2, height: 50)
        gradient.zRotation = .pi
        gradient.anchorPoint = CGPoint(x: 1, y: 0.5)
        gradient.position = CGPoint(x: 0, y: frame.height - 135)
        addChild(gradient)
        
        let label = SKLabelNode(text: "Level:")
        label.position = CGPoint(x: 30, y: frame.height - 130)
        label.fontColor = .white
        label.horizontalAlignmentMode = .left
        label.fontName = "HalvarBreit-Blk"
        label.fontSize = 22
        addChild(label)
        
        levelLabel.position = CGPoint(x: center.x, y: 30)
        levelLabel.text = "\(levelNumber + 1)"
        levelLabel.fontName = "HalvarBreit-Blk"
        levelLabel.fontSize = 22
        levelLabel.position = CGPoint(x: 30, y: frame.height - 150)
        levelLabel.fontColor = .white
        levelLabel.horizontalAlignmentMode = .left
        addChild(levelLabel)
    }
    
    private func createScoreLabels() {
        scoreNodes.0.position = CGPoint(x: center.x, y: (player1.position.y) / 2)
        scoreNodes.0.fontColor = .white
        scoreNodes.0.fontName = "HalvarBreit-Blk"
        scoreNodes.0.fontSize = 22
        addChild(scoreNodes.0)
        scoreNodes.1.position = CGPoint(x: center.x, y: (frame.height + player2.position.y) / 2 )
        scoreNodes.1.fontColor = .white
        scoreNodes.1.fontName = "HalvarBreit-Blk"
        scoreNodes.1.fontSize = 22
        addChild(scoreNodes.1)
    }
    
    private func createSemiTransparentBackground() -> SKSpriteNode {
        ball.removeFromParent()
        let background = SKSpriteNode(color: SKColor.black, size: self.size)
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 10 // Ensure it's rendered above other nodes
        background.alpha = 1  // Start invisible for the fade in animation
        return background
    }
    
    private func createBackButton() {
        backButton = SKSpriteNode(texture: SKTexture(imageNamed: "buttons/navigation/home"), size: CGSize(width: 50, height: 50))
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
        let gradient = SKSpriteNode(texture: SKTexture(imageNamed: "gradients/sideYellow"))
        gradient.size = CGSize(width: size.width / 2, height: 50)
        gradient.anchorPoint = CGPoint(x: 1, y: 0.5)
        gradient.position = CGPoint(x: size.width, y: frame.height - 135)
        addChild(gradient)
        
        let label = SKLabelNode(text: "Hits:")
        label.position = CGPoint(x: frame.width - 10, y: frame.height - 130)
        label.fontColor = .white
        label.horizontalAlignmentMode = .right
        label.fontName = "HalvarBreit-Blk"
        label.fontSize = 22
        addChild(label)
        
        hitCountNode.position = CGPoint(x: frame.width - 10, y: frame.height - 150)
        hitCount = 0
        hitCountNode.fontColor = .white
        hitCountNode.horizontalAlignmentMode = .right
        hitCountNode.fontName = "HalvarBreit-Blk"
        hitCountNode.fontSize = 22
        addChild(hitCountNode)
    }
    
    private func createTimer(seconds: Int) {
        let gradient = SKSpriteNode(texture: SKTexture(imageNamed: "gradients/sideRed"))
        gradient.size = CGSize(width: size.width / 2, height: 50)
        gradient.anchorPoint = CGPoint(x: 1, y: 0.5)
        gradient.position = CGPoint(x: size.width, y: frame.height - 85)
        addChild(gradient)
        
        let label = SKLabelNode(text: "Time left:")
        label.position = CGPoint(x: frame.width - 10, y: frame.height - 80)
        label.fontColor = .white
        label.horizontalAlignmentMode = .right
        label.fontName = "HalvarBreit-Blk"
        label.fontSize = 22
        addChild(label)
        
        timerNode.position = CGPoint(x: frame.width - 10, y: frame.height - 110)
        timeLeft = seconds
        timerNode.fontColor = .white
        timerNode.horizontalAlignmentMode = .right
        timerNode.numberOfLines = 2
        timerNode.fontName = "HalvarBreit-Blk"
        timerNode.fontSize = 22
        addChild(timerNode)
    }
    
    private func createObstacle(type: ObstacleType = .horizontal, at positionName: Position, offset: CGFloat, size: CGSize) {
        
        let position = getPosition(positionName, size: size)
        let obstacle = SKShapeNode(rectOf: size)
        
        let xOffset = type == .horizontal ? offset : 0
        let yOffset = type == .vertical ? offset : 0
        
        let startPosition = CGPoint(x: position.x - xOffset, y: position.y - yOffset)
        let endPosition = CGPoint(x: position.x + xOffset, y: position.y + yOffset)
        obstacle.path = UIBezierPath(roundedRect: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height), cornerRadius: 10).cgPath
        obstacle.position = startPosition
        obstacle.zPosition = -5
        obstacle.fillColor = .red
        obstacle.strokeColor = UIColor(red: 0.7, green: 0, blue: 0, alpha: 1)
        obstacle.lineWidth = 5
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 50)).ideal().manualMovement()
        let sequence = SKAction.sequence([SKAction.move(to: endPosition, duration: 1), SKAction.move(to: startPosition, duration: 1)])
        let animation = SKAction.repeatForever(sequence)
        obstacle.run(animation)
        addChild(obstacle)
    }
    
    private func createBoostField(type: BoostType = .boost, at positionName: Position, size: CGSize) {
        let position = getPosition(positionName, size: size)
        let boost = SKShapeNode(rectOf: size)
        boost.path = UIBezierPath(roundedRect: CGRect(x: -size.width / 2,
                                                      y: -size.height / 2,
                                                      width: size.width,
                                                      height: size.height), cornerRadius: 20).cgPath
        boost.physicsBody = SKPhysicsBody(rectangleOf: size).ideal().manualMovement()
        boost.position = position
        boost.zPosition = -5
        boost.lineWidth = 5
        boost.strokeColor = .green
        boost.fillColor = UIColor.green.withAlphaComponent(0.2)
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
        player1 = createPlayer(skin: activePlayerTexture,
                               position: CGPoint(x: size.width / 2, y: size.width / 2),
                               sizeMultiplier: 1/4)
        player2 = createPlayer(skin: configuration?.platformTexture ?? .stick,
                               position: CGPoint(x: size.width / 2, y: size.height - size.width / 2),
                               sizeMultiplier: 1/4)
        player2.zRotation = .pi
    }
    
    private func createPlayer(skin: PlatformTexture = .stick, position: CGPoint, sizeMultiplier: Double = 1/4) -> SKSpriteNode {
        let imageName = skin.rawValue
        let player = SKSpriteNode(imageNamed: imageName)
        let texture = SKTexture(imageNamed: imageName)
        let aspectRatio = texture.size().height / texture.size().width
        let width = size.width * sizeMultiplier
        let height = width * aspectRatio
        player.size = CGSize(width: width, height: height)
        player.position = position
        player.zPosition = -5

        player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: imageName),
                                           size: player.size).ideal().manualMovement()
        player.physicsBody?.categoryBitMask = playerCategory
        player.physicsBody?.collisionBitMask = ballCategory
        player.physicsBody?.contactTestBitMask = ballCategory
        return player
    }
    
    private func createBall(at position: CGPoint, speedMultiplier: CGFloat = 1) {
        let size = CGSize(width: 40, height: 40)
        let imageName = activeBallTexture.rawValue
//        let imageName = configuration?.ballTexture.rawValue ?? "apple"
        
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
        // Return if it's free play or already finished
        guard !(configuration?.isFreePlay ?? false), !isFinished else { return }

        // Determine if game finished due to time
        let isTimeFinished = timeLeft <= 0 || configuration?.time == nil

        // Determine if hit count reached the target
        let didHitTarget = configuration?.hitTarget == nil || configuration!.hitTarget! <= hitCount

        // Determine if score reached the goal target and is greater than the opponent's score
        let didReachScoreGoal = (configuration?.goalTarget == nil && score.0 > score.1) ||
                                (configuration?.goalTarget ?? 0 <= score.0 && score.0 > score.1)
        
        if isTimeFinished {
            if didHitTarget && !isFinished {
                ball.removeFromParent()
                isFinished = true
                if didReachScoreGoal {
                    let coins = Int.random(in: 50...200)
                    storeSystem.earn(coins: coins)
                    createFinishScreen(isWin: true, coinAmount: coins)
                } else if configuration?.time != nil {
                    createFinishScreen(isWin: false)
                } else {
                    return
                }
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

#Preview {
    ContentView(isGame: .constant(true))
}
