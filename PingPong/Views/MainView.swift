//
//  MainView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var observer: RoutesObserver
    
    var body: some View {
        ZStack {
            switch observer.currentRoute {
            case .mainView:
                StartView()
                    .transition(.opacity)
                    .transition(.scale)
            case .levelView:
                LevelsView(isGame: false)
                    .transition(.opacity)
                    .transition(.scale)
            case .gameView:
                LevelsView(isGame: true, isFreePlay: false)
                    .transition(.opacity)
                    .transition(.scale)
            case .settingsView:
                SettingsView()
                    .transition(.opacity)
                    .transition(.scale)
            case .storeView:
                StoreView()
                    .transition(.opacity)
                    .transition(.scale)
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(RoutesObserver())
}
