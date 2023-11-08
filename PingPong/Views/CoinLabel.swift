//
//  CoinLabel.swift
//  PingPong
//
//  Created by  admin on 08.11.2023.
//

import SwiftUI

struct CoinLabel: View {
    @StateObject var storeSystem = StoreSystem()
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Text("\(storeSystem.storedCoins)")
                    .font(.custom("HalvarBreit-Blk", size: 25))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                Image("icons/coin")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
    }
}

#Preview {
    CoinLabel()
}
