//
//  GameConfiguration.swift
//  PingPong
//
//  Created by Mnatsakan Work on 06.10.23.
//

import Foundation

enum Position {
    case center
    case left
    case right
    case top
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

enum BoostType {
    case boost
    case slow
}

enum ObstacleType {
    case vertical
    case horizontal
}

typealias Boost = (type: BoostType, position: Position, size: CGSize)
typealias Obstacle = (type: ObstacleType, position: Position, size: CGSize, offset: CGFloat)

struct GameConfiguration {
    var time: Int? = nil             // nil if no timer is needed
    var hitTarget: Int? = nil        // nil if no hit target is set
    var goalTarget: Int? = nil       // nil if no goal target is set
    var hasObstacles: Bool = false   // true if obstacles should be added
    var hasBoostFields: Bool = false // true if boost fields should be added
    var boosts: [Boost] = []         // [] if no obstacles is needed
    var obstacles: [Obstacle] = []   // [] if no boost fields is needed
}
