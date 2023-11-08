//
//  LevelView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 25.10.23.
//

import SwiftUI

struct LevelsView: View {
    @EnvironmentObject var observer: RoutesObserver
    @State var isGame: Bool = false
    @AppStorage("currentLevel") var currentLevel = 0
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
    
    func levelFor(row: Int, column: Int) -> Int {
        let isOddRow = row % 2 != 0
        let level = row * 2 + (isOddRow ? 1 - column : column)
        return level <= LevelConfig.levels.count - 1 ? level : 0
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(red: 0.1, green: 0.14, blue: 0.18)
                .ignoresSafeArea()
            
            let screenSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            let gameScene = GameScene(size: screenSize,
                                      levelNumber: currentLevel,
                                      isFreePlayMode: isFreePlay) {
                observer.currentRoute = .mainView
            }
            if isGame {
                ContentView(gameScene: gameScene, isGame: $isGame)
            } else {
                VStack {
                    ScrollView {
                        path.stroke(Color.white, lineWidth: 15)
                            .ignoresSafeArea()
                        VStack {
                            ForEach(0..<LevelConfig.levels.count / 2, id: \.self) { row in
                                HStack {
                                    ForEach(0..<2) { column in
                                        if column == 1 {
                                            Spacer()
                                        }
                                        GeometryReader { geometry in
                                            Button {
                                                currentLevel = levelFor(row: row, column: column)
                                                //                                                    isChoosingLevel.toggle()
                                                isGame.toggle()
                                            } label: {
                                                Text("\(levelFor(row: row, column: column) + 1)")
                                                    .font(.custom("HalvarBreit-Blk", size: 38))
                                                    .foregroundStyle(.white)
                                            }
                                            .disabled(completed[levelFor(row: row, column: column)] == false && currentLevel != levelFor(row: row, column: column))
                                            .frame(width: 100, height: 100)
                                            .background {
                                                let level = levelFor(row: row, column: column)
                                                Image(currentLevel == level ? "buttons/level/yellow" : completed[level] == true ? "buttons/level/green" : "buttons/level/red")
                                                    .resizable()
                                                    .overlay {
                                                        if currentLevel != level && completed[level] != true {
                                                            VStack {
                                                                Spacer(minLength: 90)
                                                                Image("icons/lock")
                                                                    .resizable()
                                                                    .frame(width: 30,
                                                                           height: 30)
                                                            }
                                                        }
                                                    }
                                            }
                                            .disabled(isFreePlay && completed[levelFor(row: row, column: column)] == false)
                                            .onAppear {
                                                let frame = geometry.frame(in: .global)
                                                let center = CGPoint(x: frame.midX,
                                                                     y: frame.minY)
                                                levelCenterPoints[levelFor(row: row, column: column)] = center
                                            }
                                        } //GEOMETRYREADER
                                        .frame(width: 100, height: 100)
                                        .padding()
                                    }
                                }
                            }
                        } //VSTACK
                        .padding(.vertical, 40)
                    } //SCROLLVIEW
                    .onAppear {
                        DispatchQueue.main.async {
                            drawPath()
                        }
                    }
                } //VSTACK
                .onAppear {
                    if completed.isEmpty {
                        for i in 0..<LevelConfig.levels.count {
                            completed[i] = false
                        }
                    }
                }
                
                ScreenTitle(title: "Select level")
                    .padding(.bottom, 20)
                    .background {
                    Color(red: 0.1, green: 0.14, blue: 0.18)
                        .ignoresSafeArea()
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
