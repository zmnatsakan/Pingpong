//
//  BackgroundStoreView.swift
//  PingPong
//
//  Created by admin on 01.11.2023.
//

import SwiftUI

struct BackgroundStoreView: View {
    @ObservedObject var storeSystem: StoreSystem
    @State private var backgroundSkins: [Skin<BackgroundTexture>] = [
            Skin(texture: .blue, price: 50, unlocked: true),
            Skin(texture: .green, price: 50),
            Skin(texture: .red, price: 50),
        ]
    
    var body: some View {
        SkinStoreView(storeSystem: storeSystem, defaultTexture: BackgroundTexture.blue, defaultSkins: backgroundSkins, key: "background")
    }
}

#Preview {
    BackgroundStoreView(storeSystem: StoreSystem())
}
