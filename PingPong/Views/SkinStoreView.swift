//
//  SkinStoreView.swift
//  PingPong
//
//  Created by  admin on 07.11.2023.
//

import SwiftUI

struct SkinTextureWrapper: RawRepresentable, Equatable {
    var rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

struct SkinStoreView<T: RawRepresentable & CaseIterable>: View where T.RawValue == String {
    @ObservedObject var storeSystem: StoreSystem
    @AppStorage("active\(T.self)") var activeTextureWrapper = SkinTextureWrapper(rawValue: "")
    @State private var skins: [Skin<T>]
    @State private var key: String

    init(storeSystem: StoreSystem, defaultTexture: T, defaultSkins: [Skin<T>] = [], key: String) {
        self.storeSystem = storeSystem
        self.activeTextureWrapper = SkinTextureWrapper(rawValue: defaultTexture.rawValue)
        let skinCodables = [SkinCodable].load(from: "\(T.self)SkinsKey")
        self.skins = skinCodables?.map({ Skin(from: $0) }) as? [Skin] ?? defaultSkins
        self.key = key
    }

    var body: some View {
        Text(key.uppercased())
            .font(.custom("HalvarBreit-Blk", size: 32))

        ScrollView {
            ForEach(skins, id: \.texture.rawValue) { skin in
                HStack {
                    Image(skin.texture.rawValue)
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 50)
                        .shadow(color: .white, radius: 8)

                    Spacer()

                    VStack {
                        Text(skin.texture.rawValue.split(separator: "/").last ?? "")
                            .textCase(.uppercase)
                            .font(.custom("HalvarBreit-Blk", size: 16))

                        HStack {
                            if !skin.unlocked {
                                Text("\(skin.price)")
                                    .font(.custom("HalvarBreit-Blk", size: 22))
                                Image("icons/coin")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .frame(height: 20)
                        Button {
                            withAnimation {
                                if skin.unlocked {
                                    activeTextureWrapper = SkinTextureWrapper(rawValue: skin.texture.rawValue)
                                } else {
                                    storeSystem.purchase(item: skin)
                                    let encoded = skins.map { SkinCodable(from: $0) }
                                    encoded.save(to: "\(T.self)SkinsKey")
                                }
                            }
                        } label: {
                            let imageName = skin.unlocked ?
                                (skin.texture.rawValue == activeTextureWrapper.rawValue ? "equipped" : "equip") : "buy"
                            Image("buttons/" + imageName)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .padding()
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    StoreView()
}
