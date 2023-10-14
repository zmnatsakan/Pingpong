//
//  MainView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SwiftUI

struct MainView: View {
    @State var isGame = false
    @State var currentLevel = 0
    
    var body: some View {
        ZStack {
            let gameScene = GameScene(size: CGSize(width: UIScreen.main.bounds.size.width,
                                                   height: UIScreen.main.bounds.size.height),
                                      levelNumber: currentLevel)
            if isGame {
                ContentView(gameScene: gameScene, isGame: $isGame)
            } else {
                ScrollView {
                    ForEach(0..<LevelConfig.levels.count, id: \.self) { index in
                        Button {
                            currentLevel = index
                            isGame.toggle()
                        } label: {
                            Text("Level \(index + 1)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
