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
    @AppStorage("activeBackgroundTexture") var activeBackgroundTexture = BackgroundTexture.wood
    
    var scene: SKScene  {
        let scene = gameScene
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .clear
        return scene
    }
    
    var body: some View {
        ZStack {
            Color.black
            SpriteView(scene: scene)
        } //ZSTACK
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isGame: .constant(true))
    }
}
