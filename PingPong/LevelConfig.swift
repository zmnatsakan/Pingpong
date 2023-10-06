//
//  LevelConfig.swift
//  PingPong
//
//  Created by Mnatsakan Work on 06.10.23.
//

struct LevelConfig {
    static let levels: [GameConfiguration] = [
        // Level 1: Timed game with obstacles and boosts, and a hit target.
        GameConfiguration(time: 90,
                          hitTarget: 5,
                          hasObstacles: true,
                          hasBoostFields: true),
        // Level 2: Timed game with boosts and a goal target.
        GameConfiguration(time: 80,
                          goalTarget: 3,
                          hasBoostFields: true),
        // Level 3: Short timed game with obstacles and a higher hit target.
        GameConfiguration(time: 60,
                          hitTarget: 10,
                          hasObstacles: true),
        // Level 4: Unlimited time with both obstacles and boosts, with a goal target.
        GameConfiguration(goalTarget: 5,
                          hasObstacles: true,
                          hasBoostFields: true),
        // Level 5: Longer timed game, with both obstacles, boosts, a hit target and a goal target.
        GameConfiguration(time: 120,
                          hitTarget: 20,
                          goalTarget: 5,
                          hasObstacles: true,
                          hasBoostFields: true),
        // Level 6: A pure timed game without any obstacles or boosts.
        GameConfiguration(time: 70),
        // Level 7: Unlimited time with a high hit target and obstacles.
        GameConfiguration(hitTarget: 30,
                          hasObstacles: true),
        // Level 8: Short timed game, with both obstacles, boosts, a hit target and a goal target.
        GameConfiguration(time: 50,
                          hitTarget: 10,
                          goalTarget: 3,
                          hasObstacles: true,
                          hasBoostFields: true),
        // Level 9: Pure mode, unlimited time with both obstacles and boosts.
        GameConfiguration(hasObstacles: true,
                          hasBoostFields: true),
        // Level 10: Very short timed game with simple hit and goal targets.
        GameConfiguration(time: 40,
                          hitTarget: 5,
                          goalTarget: 2),
    ]
}
