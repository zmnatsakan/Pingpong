//
//  LevelConfig.swift
//  PingPong
//
//  Created by Mnatsakan Work on 06.10.23.
//

import Foundation

struct LevelConfig {
    static let levels: [GameConfiguration] = [
        // Level 1: A pure timed game without any obstacles or boosts.
        GameConfiguration(time: 70,
                          boosts: [
                            (type: .boost,
                             position: .topLeft,
                             size: CGSize(width: 150, height: 150)),
                            (type: .boost,
                             position: .bottomRight,
                             size: CGSize(width: 150, height: 150)),
                          ],
                          obstacles: [
                            (type: .vertical,
                             position: .center,
                             size: CGSize(width: 50, height: 50),
                             offset: 100)
                          ]),
        
        // Level 2: Very short timed game with simple hit and goal targets.
        GameConfiguration(time: 40,
                          hitTarget: 5,
                          goalTarget: 2),
        
        // Level 3: Timed game with boosts and a goal target.
        GameConfiguration(time: 80,
                          goalTarget: 3,
                          boosts: [
                            (type: .boost,
                             position: .center,
                             size: CGSize(width: 150, height: 150)),
                          ]),
        
        // Level 4: Short timed game with obstacles and a higher hit target.
        GameConfiguration(time: 60,
                          hitTarget: 10,
                          obstacles: [
                            (type: .horizontal,
                             position: .center,
                             size: CGSize(width: 50, height: 50),
                             offset: 100)
                          ]),
        
        // Level 5: Pure mode, unlimited time with both obstacles and boosts.
        GameConfiguration(boosts: [
                            (type: .boost,
                             position: .topLeft,
                             size: CGSize(width: 150, height: 150)),
                            (type: .boost,
                             position: .bottomRight,
                             size: CGSize(width: 150, height: 150)),
                          ],
                          obstacles: [
                            (type: .vertical,
                             position: .center,
                             size: CGSize(width: 50, height: 50),
                             offset: 100)
                          ]),
        
        // Level 6: Timed game with obstacles and boosts, and a hit target.
        GameConfiguration(time: 90,
                          hitTarget: 5,
                          boosts: [
                            (type: .boost,
                             position: .topLeft,
                             size: CGSize(width: 150, height: 150)),
                            (type: .boost,
                             position: .bottomRight,
                             size: CGSize(width: 150, height: 150)),
                          ],
                          obstacles: [
                            (type: .vertical,
                             position: .center,
                             size: CGSize(width: 50, height: 50),
                             offset: 100)
                          ]),
        
        // Level 7: Short timed game, with both obstacles, boosts, a hit target and a goal target.
        GameConfiguration(time: 50,
                          hitTarget: 10,
                          goalTarget: 3,
                          boosts: [
                            (type: .boost,
                             position: .topLeft,
                             size: CGSize(width: 150, height: 150)),
                            (type: .boost,
                             position: .bottomRight,
                             size: CGSize(width: 150, height: 150)),
                          ],
                          obstacles: [
                            (type: .vertical,
                             position: .center,
                             size: CGSize(width: 50, height: 50),
                             offset: 100)
                          ]),
        
        // Level 8: Unlimited time with both obstacles and boosts, with a goal target.
        GameConfiguration(goalTarget: 5,
                          boosts: [
                            (type: .boost,
                             position: .topLeft,
                             size: CGSize(width: 150, height: 150)),
                            (type: .boost,
                             position: .bottomRight,
                             size: CGSize(width: 150, height: 150)),
                          ],
                          obstacles: [
                            (type: .vertical,
                             position: .center,
                             size: CGSize(width: 50, height: 50),
                             offset: 100)
                          ]),
        
        // Level 9: Unlimited time with a high hit target and obstacles.
        GameConfiguration(hitTarget: 30,
                          obstacles: [
                            (type: .vertical,
                             position: .center,
                             size: CGSize(width: 50, height: 50),
                             offset: 100)
                          ]),
        
        // Level 10: Longer timed game, with both obstacles, boosts, a hit target and a goal target.
        GameConfiguration(time: 120,
                          hitTarget: 20,
                          goalTarget: 5,
                          boosts: [
                            (type: .boost,
                             position: .topLeft,
                             size: CGSize(width: 150, height: 150)),
                            (type: .boost,
                             position: .bottomRight,
                             size: CGSize(width: 150, height: 150)),
                          ],
                          obstacles: [
                            (type: .vertical,
                             position: .center,
                             size: CGSize(width: 50, height: 50),
                             offset: 100)
                          ])
    ]
}
