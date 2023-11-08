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
    
    @State var levelCenterPoints: [Int: CGPoint] = [:]
    @State var path: Path = Path()
    
    func drawPath() {
        if !levelCenterPoints.isEmpty {
            path.move(to: levelCenterPoints[0]!)
            for i in 1..<levelCenterPoints.count {
                path.addLine(to: levelCenterPoints[i]!)
                print(levelCenterPoints[i]!)
            }
        } else {
            print("points empty")
        }
    }
    
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
                    
                } //VSTACK
                VStack {
                    GeometryReader { _ in
                        path.stroke(Color.white, lineWidth: 15)
                                            .ignoresSafeArea()
                        ScrollView {
                            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                                ForEach(0..<LevelConfig.levels.count, id: \.self) { index in
                                    GeometryReader { geometry in
                                        Button {
                                            currentLevel = index
                                            isGame.toggle()
                                        } label: {
                                            Text("\(index + 1)")
                                                .font(.title)
                                                .frame(maxWidth: .infinity)
                                        }
                                        .frame(width: 100, height: 100)
                                        .background {
                                            RoundedRectangle(cornerRadius: 300)
                                                .foregroundStyle(.gray)
                                        }
                                        .disabled(isFreePlay && completed[index] == false)
                                        .onAppear {
                                            let frame = geometry.frame(in: .global)
                                            let center = CGPoint(x: frame.midX,
                                                                 y: frame.midY)
                                            levelCenterPoints[index] = center
                                        }
                                    } //GEOMETRYREADER
                                    .frame(width: 100, height: 100)
                                }
                            } //LAZYVGRID
                        } //SCROLLVIEW
                        .onAppear {
                            DispatchQueue.main.async {
                                drawPath()
                            }
                        }
                    } //GEOMETRYREADER
                    
//                    Picker("Appearance", selection: $isFreePlay) {
//                        ForEach([false, true], id: \.self) {
//                            Text($0 ? "Freeplay" : "Classic")
//                        }
//                    }
//                    .padding()
//                    .pickerStyle(.segmented)
//                    
//                    ScrollView {
//                        ForEach(0..<LevelConfig.levels.count, id: \.self) { index in
//                            Button {
//                                currentLevel = index
//                                isGame.toggle()
//                            } label: {
//                                Text("Level \(index + 1)")
//                                    .font(.title)
//                                    .frame(maxWidth: .infinity)
//                            }
//                            .buttonStyle(.borderedProminent)
//                            .padding(.horizontal)
//                            .disabled(isFreePlay && completed[index] == false)
//                        }
//                    } //SCROLLVIEW
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
    LevelsView(isGame: false, isFreePlay: false)
}
