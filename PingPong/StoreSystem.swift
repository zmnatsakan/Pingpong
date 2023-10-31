//
//  CoinSystem.swift
//  PingPong
//
//  Created by Mnatsakan Work on 31.10.23.
//

import SwiftUI

final class StoreSystem: ObservableObject {
    @AppStorage("coins") var storedCoins = 0
    
    func earn(coins: Int) {
        storedCoins += coins
    }

    func spend(coins: Int) -> Bool {
        if storedCoins >= coins {
            storedCoins -= coins
            return true
        } else {
            return false
        }
    }
    
    func purchase(item: some Purchasable) {
        if spend(coins: item.price) {
            item.purchase()
        }
    }
}
