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
        GameConfiguration(ballSpeedMultiplier: 3,
                          time: 70),
        
        // Level 2: Very short timed game with simple hit and goal targets.
        GameConfiguration(ballSpeedMultiplier: 3,
                          time: 40,
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
                          ]),
        // Level 11: A time-limited challenge with increased obstacles.
        GameConfiguration(time: 100,
                          hitTarget: 15,
                          obstacles: [
                            (type: .vertical, position: .left, size: CGSize(width: 50, height: 50), offset: 50),
                            (type: .horizontal, position: .center, size: CGSize(width: 50, height: 50), offset: 50),
                            (type: .vertical, position: .right, size: CGSize(width: 50, height: 50), offset: 50)
                          ]),

        // Level 12: Intense speed challenge with more boosts.
        GameConfiguration(ballSpeedMultiplier: 4,
                          time: 70,
                          hitTarget: 10,
                          boosts: [
                            (type: .boost, position: .center, size: CGSize(width: 100, height: 100))
                          ]),

        // Level 13: Short timed challenge with dense obstacles.
        GameConfiguration(time: 50,
                          hitTarget: 8,
                          obstacles: [
                            (type: .vertical, position: .left, size: CGSize(width: 30, height: 30), offset: 40),
                            (type: .vertical, position: .right, size: CGSize(width: 30, height: 30), offset: 40),
                            (type: .horizontal, position: .center, size: CGSize(width: 30, height: 30), offset: 40)
                          ]),

        // Level 14: Higher goals with limited time and strategic boosts.
        GameConfiguration(time: 90,
                          goalTarget: 7,
                          boosts: [
                            (type: .boost, position: .center, size: CGSize(width: 130, height: 130))
                          ]),

        // Level 15: Strategy level with boosts and obstacles together.
        GameConfiguration(time: 110,
                          hitTarget: 18,
                          boosts: [
                            (type: .boost, position: .bottomLeft, size: CGSize(width: 120, height: 120))
                          ],
                          obstacles: [
                            (type: .horizontal, position: .center, size: CGSize(width: 40, height: 40), offset: 60)
                          ]),

        // Level 16: Pure speed challenge with added difficulty.
        GameConfiguration(ballSpeedMultiplier: 5,
                          time: 60,
                          hitTarget: 12),

        // Level 17: Dense boosts but with many obstacles.
        GameConfiguration(time: 130,
                          hitTarget: 25,
                          boosts: [
                            (type: .boost, position: .topRight, size: CGSize(width: 120, height: 120)),
                            (type: .boost, position: .bottomLeft, size: CGSize(width: 120, height: 120))
                          ],
                          obstacles: [
                            (type: .vertical, position: .center, size: CGSize(width: 40, height: 40), offset: 70)
                          ]),

        // Level 18: Unlimited time but with a challenging hit target.
        GameConfiguration(hitTarget: 40,
                          obstacles: [
                            (type: .horizontal, position: .center, size: CGSize(width: 60, height: 60), offset: 80)
                          ]),

        // Level 19: Short burst level with both high hit and goal targets.
        GameConfiguration(time: 45,
                          hitTarget: 15,
                          goalTarget: 4),

        // Level 20: The ultimate challenge with everything.
        GameConfiguration(time: 150,
                          hitTarget: 30,
                          goalTarget: 10,
                          boosts: [
                            (type: .boost, position: .topLeft, size: CGSize(width: 140, height: 140)),
                            (type: .boost, position: .bottomRight, size: CGSize(width: 140, height: 140))
                          ],
                          obstacles: [
                            (type: .vertical, position: .left, size: CGSize(width: 40, height: 40), offset: 90),
                            (type: .horizontal, position: .center, size: CGSize(width: 40, height: 40), offset: 90)
                          ])
    ]
}
