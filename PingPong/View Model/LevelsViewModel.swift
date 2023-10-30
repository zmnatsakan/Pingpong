//
//  LevelsViewModel.swift
//  PingPong
//
//  Created by Mnatsakan Work on 30.10.23.
//

import SwiftUI

final class LevelsViewModel: ObservableObject {
    @State var isGame = false
    @State var currentLevel = 0
    @State var isFreePlayMode: Bool = false
    
    let screenSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    var gameScene: GameScene {
        GameScene(size: screenSize,
                  levelNumber: currentLevel,
                  isFreePlayMode: isFreePlayMode) {
            self.isGame = false
        }
    }
}
