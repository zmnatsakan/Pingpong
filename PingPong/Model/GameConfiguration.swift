//
//  GameConfiguration.swift
//  PingPong
//
//  Created by Mnatsakan Work on 06.10.23.
//

import Foundation

typealias Boost = (type: BoostType, position: Position, size: CGSize)
typealias Obstacle = (type: ObstacleType, position: Position, size: CGSize, offset: CGFloat)

struct GameConfiguration {
    private(set) var isFreePlay: Bool = false   // false by default
    var playerTexture: PlayerTexture = .lens    // lens texture by default
    var ballTexture: BallTexture = .apple       // apple texture by default
    var ballSpeedMultiplier: CGFloat = 1.0      // 1 if default speed
    var computerSpeedMultiplier: CGFloat = 1.0  // 1 if default speed
    var time: Int? = nil                        // nil if no timer is needed
    var hitTarget: Int? = nil                   // nil if no hit target is set
    var goalTarget: Int? = nil                  // nil if no goal target is set
    var hasObstacles: Bool = false              // true if obstacles should be added
    var hasBoostFields: Bool = false            // true if boost fields should be added
    var boosts: [Boost] = []                    // [] if no obstacles is needed
    var obstacles: [Obstacle] = []              // [] if no boost fields is needed
    
    mutating func makeFreePlay() {
        isFreePlay = true
    }
}
