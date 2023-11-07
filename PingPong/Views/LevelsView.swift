//
//  LevelView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 25.10.23.
//

import SwiftUI

struct LevelsView: View {
    @State var isGame: Bool = false
    @AppStorage("current level") var currentLevel = 0
    @State var isFreePlay: Bool = false
    @AppStorage("completed") var completed: [Int: Bool] = [:]
    
    var body: some View {
        ZStack {
            let screenSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            let gameScene = GameScene(size: screenSize,
                                      levelNumber: currentLevel,
                                      isFreePlayMode: isFreePlay) {
                self.isGame = false
            }
            if isGame {
                ContentView(gameScene: gameScene, isGame: $isGame)
            } else {
                VStack {
                    Picker("Appearance", selection: $isFreePlay) {
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
                            .disabled(isFreePlay && completed[index] == false)
                        }
                    } //SCROLLVIEW
                } //VSTACK
                .onAppear {
                    if completed.isEmpty {
                        for i in 0..<LevelConfig.levels.count {
                            completed[i] = false
                        }
                    }
                }
            }
        } //ZSTACK
        .navigationTitle("Levels")
        .onAppear {
            print("OnAppear:", self.isGame)
        }
    }
}

#Preview {
    LevelsView(isGame: true, isFreePlay: false)
}
