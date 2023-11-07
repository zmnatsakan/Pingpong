//
//  StoreView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 31.10.23.
//

import SwiftUI

struct StoreView: View {
    
    @ObservedObject var storeSystem = StoreSystem()
    @State var buttonColor: Color = .blue
    
    
    init() {
        self.storeSystem = StoreSystem()
        self.buttonColor = .blue
     }
    

    
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
            Text("Coins: \(storeSystem.storedCoins)")
                .font(.title)
            
            HStack {
                Button("earn 10") {
                    storeSystem.earn(coins: 10)
                }
                .buttonStyle(.bordered)
                Button("spend 30") {
                    if !storeSystem.spend(coins: 30) {
                        pulse()
                    }
                }
                .buttonStyle(.bordered)
                .foregroundStyle(buttonColor)
            }
            
            Button("Reset") {
                if let bundleID = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.14, blue: 0.18)
                .ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack {
                        BallStoreView(storeSystem: storeSystem)
                        Divider()
                        PlatformStoreView(storeSystem: storeSystem)
                        Divider()
                        BackgroundStoreView(storeSystem: storeSystem)
                    }
                }
                test()
            }
        }
    }
}

#Preview {
    StoreView()
}
