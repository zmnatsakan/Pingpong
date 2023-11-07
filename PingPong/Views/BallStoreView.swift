//
//  SkinStoreView.swift
//  PingPong
//
//  Created by admin on 01.11.2023.
//

import SwiftUI

struct BallStoreView: View {
    @ObservedObject var storeSystem: StoreSystem
    @State private var ballSkins: [Skin<BallTexture>] = [
        Skin(texture: .apple, price: 50, unlocked: true),
        Skin(texture: .appleCore, price: 50),
        Skin(texture: .avocado, price: 50),
        Skin(texture: .banana, price: 50),
        Skin(texture: .watermelon, price: 50),
    ]
    
    var body: some View {
        SkinStoreView(storeSystem: storeSystem, defaultTexture: BallTexture.apple, defaultSkins: ballSkins, key: "ball")
    }
}

#Preview {
    BallStoreView(storeSystem: StoreSystem())
}
