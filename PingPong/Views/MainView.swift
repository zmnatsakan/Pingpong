//
//  MainView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SwiftUI

struct MainView: View {
    @State var isGame = false
    @ObservedObject var gameScene = GameScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    
    var body: some View {
        ZStack {
            if isGame {
                ContentView(gameScene: GameScene(size: CGSize(width: UIScreen.main.bounds.size.width,
                                                              height: UIScreen.main.bounds.size.height),
                                                 configuration: LevelConfig.levels.randomElement()!), isGame: $isGame)
            } else {
                Button("PLAY") {
                    gameScene.reloadScene()
                    isGame.toggle()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
