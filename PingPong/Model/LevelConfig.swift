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
        GameConfiguration(platformTexture: PlatformTexture.circle,
                          ballTexture: .apple,
                          ballSpeedMultiplier: 3,
                          time: 7),
        
        // Level 2: Very short timed game with simple hit and goal targets.
        GameConfiguration(platformTexture: PlatformTexture.stick,
                          ballTexture: .appleCore,
                          ballSpeedMultiplier: 3,
                          time: 40,
                          hitTarget: 5,
                          goalTarget: 2),
        
        // Level 3: Timed game with boosts and a goal target.
        GameConfiguration(platformTexture: PlatformTexture.red,
                          ballTexture: .banana,
                          time: 80,
                          goalTarget: 3,
                          boosts: [
                            (type: .boost,
                             position: .center,
                             size: CGSize(width: 150, height: 150)),
                          ]),
        
        // Level 4: Short timed game with obstacles and a higher hit target.
        GameConfiguration(ballTexture: .avocado,
                          time: 60,
                          hitTarget: 10,
                          obstacles: [
                            (type: .horizontal,
                             position: .center,
                             size: CGSize(width: 50, height: 50),
                             offset: 100)
                          ]),
        
        // Level 5: Pure mode, unlimited time with both obstacles and boosts.
        GameConfiguration(ballTexture: .watermelon,
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
        
        // Level 6: Timed game with obstacles and boosts, and a hit target.
        GameConfiguration(ballTexture: .apple,
                          time: 90,
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
        GameConfiguration(ballTexture: .appleCore,
                          time: 50,
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
        GameConfiguration(hitTarget: 50,
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
        
        // Level 9: Unlimited time with a high hit target and obstacles.
        GameConfiguration(ballTexture: .avocado,
                          ballSpeedMultiplier: 3, 
                          hitTarget: 30,
                          obstacles: [
                            (type: .vertical,
                             position: .center,
                             size: CGSize(width: 50, height: 50),
                             offset: 100)
                          ]),
        
        // Level 10: Longer timed game, with both obstacles, boosts, a hit target and a goal target.
        GameConfiguration(ballTexture: .apple,
                          time: 120,
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
        GameConfiguration(ballTexture: .avocado,
                          time: 100,
                          hitTarget: 15,
                          obstacles: [
                            (type: .vertical, position: .left, size: CGSize(width: 50, height: 50), offset: 50),
                            (type: .horizontal, position: .center, size: CGSize(width: 50, height: 50), offset: 50),
                            (type: .vertical, position: .right, size: CGSize(width: 50, height: 50), offset: 50)
                          ]),
        
        // Level 12: Intense speed challenge with more boosts.
        GameConfiguration(ballTexture: .apple,
                          ballSpeedMultiplier: 4,
                          time: 70,
                          hitTarget: 10,
                          boosts: [
                            (type: .boost, position: .center, size: CGSize(width: 100, height: 100))
                          ]),
        
        // Level 13: Short timed challenge with dense obstacles.
        GameConfiguration(ballTexture: .apple,
                          time: 50,
                          hitTarget: 8,
                          obstacles: [
                            (type: .vertical, position: .left, size: CGSize(width: 30, height: 30), offset: 40),
                            (type: .vertical, position: .right, size: CGSize(width: 30, height: 30), offset: 40),
                            (type: .horizontal, position: .center, size: CGSize(width: 30, height: 30), offset: 40)
                          ]),
        
        // Level 14: Higher goals with limited time and strategic boosts.
        GameConfiguration(ballTexture: .avocado,
                          time: 90,
                          goalTarget: 7,
                          boosts: [
                            (type: .boost, position: .center, size: CGSize(width: 130, height: 130))
                          ]),
        
        // Level 15: Strategy level with boosts and obstacles together.
        GameConfiguration(ballTexture: .appleCore,
                          time: 110,
                          hitTarget: 18,
                          boosts: [
                            (type: .boost, position: .bottomLeft, size: CGSize(width: 120, height: 120))
                          ],
                          obstacles: [
                            (type: .horizontal, position: .center, size: CGSize(width: 40, height: 40), offset: 60)
                          ]),
        
        // Level 16: Pure speed challenge with added difficulty.
        GameConfiguration(ballTexture: .apple,
                          ballSpeedMultiplier: 5,
                          time: 60,
                          hitTarget: 12),
        
        // Level 17: Dense boosts but with many obstacles.
        GameConfiguration(ballTexture: .watermelon,
                          time: 130,
                          hitTarget: 25,
                          boosts: [
                            (type: .boost, position: .topRight, size: CGSize(width: 120, height: 120)),
                            (type: .boost, position: .bottomLeft, size: CGSize(width: 120, height: 120))
                          ],
                          obstacles: [
                            (type: .vertical, position: .center, size: CGSize(width: 40, height: 40), offset: 70)
                          ]),
        
        // Level 18: Unlimited time but with a challenging hit target.
        GameConfiguration(ballTexture: .apple,
                          hitTarget: 40,
                          obstacles: [
                            (type: .horizontal, position: .center, size: CGSize(width: 60, height: 60), offset: 80)
                          ]),
        
        // Level 19: Short burst level with both high hit and goal targets.
        GameConfiguration(ballTexture: .banana,
                          time: 45,
                          hitTarget: 15,
                          goalTarget: 4),
        
        // Level 20: The ultimate challenge with everything.
        GameConfiguration(ballTexture: .apple,
                          time: 150,
                          hitTarget: 30,
                          goalTarget: 10,
                          boosts: [
                            (type: .boost, position: .topLeft, size: CGSize(width: 140, height: 140)),
                            (type: .boost, position: .bottomRight, size: CGSize(width: 140, height: 140))
                          ],
                          obstacles: [
                            (type: .vertical, position: .left, size: CGSize(width: 40, height: 40), offset: 90),
                            (type: .horizontal, position: .center, size: CGSize(width: 40, height: 40), offset: 90)
                          ]),
        // Level 21: Rotation of ball textures, emphasizing speed.
        GameConfiguration(ballTexture: .banana,
                          ballSpeedMultiplier: 5,
                          time: 65,
                          hitTarget: 13),
        
        // Level 22: The field of boosts with limited time.
        GameConfiguration(ballTexture: .watermelon,
                          time: 55,
                          hitTarget: 10,
                          boosts: [
                            (type: .boost, position: .top, size: CGSize(width: 130, height: 130)),
                            (type: .boost, position: .bottom, size: CGSize(width: 130, height: 130)),
                            (type: .boost, position: .center, size: CGSize(width: 130, height: 130))
                          ]),
        
        // Level 23: Obstacle maze with a goal target.
        GameConfiguration(ballTexture: .appleCore,
                          time: 110,
                          goalTarget: 6,
                          obstacles: [
                            (type: .vertical, position: .left, size: CGSize(width: 30, height: 30), offset: 45),
                            (type: .horizontal, position: .center, size: CGSize(width: 30, height: 30), offset: 45)
                          ]),
        
        // Level 24: Speed test with goal target emphasis.
        GameConfiguration(ballTexture: .avocado,
                          ballSpeedMultiplier: 6,
                          time: 40,
                          goalTarget: 4),
        
        // Level 25: Unlimited time with an ultra-high hit target.
        GameConfiguration(ballTexture: .banana,
                          hitTarget: 150,
                          boosts: [
                            (type: .boost, position: .center, size: CGSize(width: 120, height: 120))
                          ]),
        
        // Level 26: Limited time, focus on avoiding obstacles.
        GameConfiguration(ballTexture: .watermelon,
                          time: 75,
                          hitTarget: 50,
                          obstacles: [
                            (type: .horizontal, position: .top, size: CGSize(width: 40, height: 40), offset: 55),
                            (type: .horizontal, position: .bottom, size: CGSize(width: 40, height: 40), offset: 55)
                          ]),
        
        // Level 27: Strategy level with hit targets in a maze of boosts.
        GameConfiguration(ballTexture: .appleCore,
                          time: 90,
                          hitTarget: 18,
                          boosts: [
                            (type: .boost, position: .topLeft, size: CGSize(width: 110, height: 110)),
                            (type: .boost, position: .topRight, size: CGSize(width: 110, height: 110)),
                            (type: .boost, position: .bottomLeft, size: CGSize(width: 110, height: 110)),
                            (type: .boost, position: .bottomRight, size: CGSize(width: 110, height: 110))
                          ]),
        
        // Level 28: All about hitting the goals.
        GameConfiguration(ballTexture: .avocado,
                          time: 100,
                          goalTarget: 10),
        
        // Level 29: Challenges with both high hit and goal targets.
        GameConfiguration(ballTexture: .banana,
                          time: 130,
                          hitTarget: 125,
                          goalTarget: 15,
                          boosts: [
                            (type: .boost, position: .center, size: CGSize(width: 140, height: 140))
                          ]),
        
        // Level 30: The final challenge. Everything at its peak.
        GameConfiguration(ballTexture: .watermelon,
                          ballSpeedMultiplier: 7,
                          time: 160,
                          hitTarget: 100,
                          goalTarget: 25,
                          boosts: [
                            (type: .boost, position: .top, size: CGSize(width: 140, height: 140)),
                            (type: .boost, position: .bottom, size: CGSize(width: 140, height: 140))
                          ],
                          obstacles: [
                            (type: .horizontal, position: .center, size: CGSize(width: 100, height: 50), offset: 105)
                          ])
    ]
}
