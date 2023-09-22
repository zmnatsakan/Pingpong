//
//  ContentView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @Binding var isGame: Bool
    @StateObject var gameScene = GameScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
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
