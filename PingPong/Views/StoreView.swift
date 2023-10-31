//
//  StoreView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 31.10.23.
//

import SwiftUI

protocol Purchasable {
    var price: Int { get }
    func purchase()
}

struct StoreView: View {
    @AppStorage("activeBallTexture") var activeBallTexture = BallTexture.apple
    @ObservedObject var coinSystem = StoreSystem()
    @State var buttonColor: Color = .blue
//    @State var activeBallTexture = BallTexture.apple
    
    @State private var ballSkins: [BallSkin]
    
    init() {
        self.coinSystem = StoreSystem()
        self.buttonColor = .blue
        self.activeBallTexture = BallTexture.apple
        let skinCodables = [SkinCodable].load(from: "ballSkinsKey")
        self.ballSkins = skinCodables?.map({ BallSkin(from: $0) }) as? [BallSkin] ??
        [
            BallSkin(texture: .apple, price: 50, unlocked: true),
            BallSkin(texture: .appleCore, price: 50),
            BallSkin(texture: .avocado, price: 50),
            BallSkin(texture: .banana, price: 50),
            BallSkin(texture: .watermelon, price: 50),
        ]
    }
    
    private let columns = [GridItem(.flexible(minimum: 50, 
                                              maximum: 100), spacing: 30),
                           GridItem(.flexible(minimum: 50,
                                              maximum: 100), spacing: 30),
                           GridItem(.flexible(minimum: 50,
                                              maximum: 100), spacing: 30),]
    
    private func pulse() {
        buttonColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation {
                buttonColor = .blue
            }
        }
    }
    
    private func test() -> some View{
        VStack {
            Text("Coins: \(coinSystem.storedCoins)")
                .font(.title)
            
            HStack {
                Button("earn 10") {
                    coinSystem.earn(coins: 10)
                }
                .buttonStyle(.bordered)
                Button("spend 30") {
                    if !coinSystem.spend(coins: 30) {
                        pulse()
                    }
                }
                .buttonStyle(.bordered)
                .foregroundStyle(buttonColor)
            }
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(ballSkins, id: \.texture) { skin in
                VStack {
                    Image(skin.texture.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                    let title = skin.unlocked ?
                    (skin.texture == activeBallTexture ? "Selected" :
                        "Select") :
                    "\(skin.price)"
                    
                    Text(title)
                        .foregroundStyle(.white)
                        .font(.title3.bold())
                }
                .padding(5)
                .background {
                    let color: Color = skin.unlocked ? skin.texture == activeBallTexture ? .green : .blue : .gray
                    RoundedRectangle(cornerRadius: 10).foregroundStyle(color.opacity(0.5))
                }
                .onTapGesture {
                    if skin.unlocked {
                        activeBallTexture = skin.texture
                    } else {
                        coinSystem.purchase(item: skin)
                        let encoded = ballSkins.map { SkinCodable(from: $0) }
                        encoded.save(to: "ballSkinsKey")
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        
        test()
    }
}

#Preview {
    StoreView()
}
