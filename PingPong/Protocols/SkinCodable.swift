//
//  SkinCodable.swift
//  PingPong
//
//  Created by admin on 01.11.2023.
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
}
