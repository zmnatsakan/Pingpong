//
//  PlatformStoreView.swift
//  PingPong
//
//  Created by  admin on 03.11.2023.
//

import SwiftUI

struct PlatformStoreView: View {
    @ObservedObject var storeSystem: StoreSystem
    @State private var platformSkins: [Skin<PlatformTexture>] = [
            Skin(texture: .stick, price: 50, unlocked: true),
            Skin(texture: .circle, price: 50),
            Skin(texture: .green, price: 50),
            Skin(texture: .red, price: 50),
        ]
    
    var body: some View {
        SkinStoreView(storeSystem: storeSystem, defaultTexture: PlatformTexture.stick, defaultSkins: platformSkins, key: "platform")
    }
}

#Preview {
    PlatformStoreView(storeSystem: StoreSystem())
}
