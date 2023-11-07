//
//  BallSkin.swift
//  PingPong
//
//  Created by Mnatsakan Work on 31.10.23.
//

import Foundation

final class Skin<Texture: RawRepresentable & CaseIterable>: Purchasable where Texture.RawValue == String {
    var texture: Texture
    var price: Int
    var unlocked: Bool = false
    
    init(texture: Texture, price: Int, unlocked: Bool = false) {
        self.texture = texture
        self.price = price
        self.unlocked = unlocked
    }
    
    init(from skinCodable: SkinCodable) {
        self.texture = Texture(rawValue: skinCodable.texture) ?? Texture.allCases.randomElement()!
        self.price = skinCodable.price
        self.unlocked = skinCodable.unlocked
    }
    
    func purchase() {
        unlocked = true
    }
}

extension SkinCodable {
    init(from skin: some Purchasable) {
        self.texture = skin.texture.rawValue
        self.price = skin.price
        self.unlocked = skin.unlocked
    }
}
