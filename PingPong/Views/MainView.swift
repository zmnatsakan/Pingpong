//
//  MainView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SwiftUI

struct MainView: View {
    @State var isGame = false
    
    var body: some View {
        ZStack {
            if isGame {
                ContentView(isGame: $isGame)
            } else {
                Button("PLAY") {
                    isGame = true
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
