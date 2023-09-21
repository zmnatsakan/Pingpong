//
//  GameScene.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SpriteKit

final class GameScene: SKScene, ObservableObject {
    @Published var score = (0, 0)
    private var player1 = SKSpriteNode()
    private var player2 = SKSpriteNode()
    private var ball = SKShapeNode()
        
    override init(size: CGSize) {
        super.init(size: size)
        setupObjects()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let isTouchBelowCenter = touch.location(in: self).y < size.height / 2
        let player = isTouchBelowCenter ? player1 : player2
        
        let touchLocation = touch.location(in: self)
        let playerWidth = player1.size.width
        let minX = playerWidth / 2 + 5
        let maxX = size.width - playerWidth / 2 - 5
        
        guard minX < touchLocation.x && touchLocation.x < maxX else { return }
        
        player.position.x = touchLocation.x
    }
    
    override func didFinishUpdate() {
        if ball.position.y > size.height {
            score.0 += 1
            setupObjects()
        } else if ball.position.y < 0 {
            score.1 += 1
            setupObjects()
        }
    }
    
    
    //MARK: - Setup objects
    private func setupObjects() {
        removeAllChildren()
        self.createPlayers()
        self.createBall(position: CGPoint(x: size.width / 2, y: size.height / 2))
        
        createWalls()
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        addChild(player1)
        addChild(player2)
        addChild(ball)
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
        ball.physicsBody?.velocity = CGVector(dx: 200, dy: 100)
        ball.fillColor = .white
        self.ball = ball
    }
}
