//
//  LevelView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 25.10.23.
//

import SwiftUI

struct LevelsView: View {
    @State var isGame = false
    @State var currentLevel = 0
    @State var isFreePlayMode: Bool = false
    
    var body: some View {
        ZStack {
            let screenSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            let gameScene = GameScene(size: screenSize,
                                      levelNumber: currentLevel,
                                      isFreePlayMode: isFreePlayMode)
            if isGame {
                ContentView(gameScene: gameScene, isGame: $isGame)
            } else {
                VStack {
                    Picker("Appearance", selection: $isFreePlayMode) {
                        ForEach([false, true], id: \.self) {
                            Text($0 ? "Freeplay" : "Classic")
                        }
                    }
                    .padding()
                    .pickerStyle(.segmented)
                    
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
                    } //SCROLLVIEW
                } //VSTACK
            }
        } //ZSTACK
        .navigationTitle("Levels")
    }
}

#Preview {
    LevelsView()
}
