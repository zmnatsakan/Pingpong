//
//  ContentView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @ObservedObject var gameScene: GameScene = GameScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), levelNumber: 0)
    @Binding var isGame: Bool
    var scene: SKScene  {
        let scene = gameScene
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .black
        return scene
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            SpriteView(scene: scene)
            
            VStack {
                Text("\(gameScene.score.1)")
                    .foregroundColor(.white)
                Spacer()
                Text("\(gameScene.score.0)")
                    .foregroundColor(.white)
                    .onTapGesture {
                        gameScene.reloadScene()
                    }
            }
            .font(.system(size: 60).weight(.bold))
            .monospaced()
            .animation(.easeInOut, value: gameScene.score.0 + gameScene.score.1)
        } //ZSTACK
        .onChange(of: gameScene.isBack) { _ in
            isGame = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isGame: .constant(true))
    }
}
