//
//  Purchasable.swift
//  PingPong
//
//  Created by  admin on 02.11.2023.
//

import Foundation

protocol Purchasable {
    associatedtype Skin: RawRepresentable where Skin.RawValue == String
    var texture: Skin { get set }
    var price: Int { get }
    var unlocked: Bool { get set }
    func purchase()
}
