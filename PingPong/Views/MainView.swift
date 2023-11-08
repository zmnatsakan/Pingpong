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
        switch observer.currentRoute {
        case .mainView:
            StartView()
        case .levelView:
            LevelsView(isGame: false)
        case .gameView:
            LevelsView(isGame: true, isFreePlay: false)
        case .settingsView:
            SettingsView()
        case .storeView:
            StoreView()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(RoutesObserver())
}
