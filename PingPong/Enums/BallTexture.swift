//
//  BallTexture.swift
//  PingPong
//
//  Created by Mnatsakan Work on 16.10.23.
//

typealias StringIterable = RawRepresentable & CaseIterable

enum BallTexture: String, CaseIterable {
    case apple = "ball/apple"
    case appleCore = "ball/apple-core"
    case avocado = "ball/avocado"
    case banana = "ball/banana"
    case watermelon = "ball/watermelon"
}
