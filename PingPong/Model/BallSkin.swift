//
//  BallSkin.swift
//  PingPong
//
//  Created by Mnatsakan Work on 31.10.23.
//

import Foundation

struct SkinCodable: Codable {
    let texture: String
    let price: Int
    let unlocked: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.texture = try container.decode(String.self, forKey: .texture)
        self.price = try container.decode(Int.self, forKey: .price)
        self.unlocked = try container.decode(Bool.self, forKey: .unlocked)
    }
    
    init(from ballSkin: BallSkin) {
        self.texture = ballSkin.texture.rawValue
        self.price = ballSkin.price
        self.unlocked = ballSkin.unlocked
    }
}

final class BallSkin: Purchasable {
    let texture: BallTexture
    var price: Int
    var unlocked: Bool = false
    
    init(texture: BallTexture, price: Int, unlocked: Bool = false) {
        self.texture = texture
        self.price = price
        self.unlocked = unlocked
    }
    
    init(from skinCodable: SkinCodable) {
        self.texture = BallTexture(rawValue: skinCodable.texture) ?? .apple
        self.price = skinCodable.price
        self.unlocked = skinCodable.unlocked
    }
    
    func purchase() {
        unlocked = true
    }
}
