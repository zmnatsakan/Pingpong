//
//  ContactType.swift
//  PingPong
//
//  Created by Mnatsakan Work on 06.10.23.
//

import SpriteKit

enum ContactType {
    case ballWithBoost
    case ballWithPlayer
    case none
    
    init(contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == BitMask.ball.rawValue && contact.bodyB.categoryBitMask == BitMask.detector.rawValue) ||
           (contact.bodyA.categoryBitMask == BitMask.detector.rawValue && contact.bodyB.categoryBitMask == BitMask.ball.rawValue) {
            self = .ballWithBoost
        } else if (contact.bodyA.categoryBitMask == BitMask.ball.rawValue && contact.bodyB.categoryBitMask == BitMask.player.rawValue) ||
                  (contact.bodyA.categoryBitMask == BitMask.player.rawValue && contact.bodyB.categoryBitMask == BitMask.ball.rawValue) {
            self = .ballWithPlayer
        } else {
            self = .none
        }
    }
}
