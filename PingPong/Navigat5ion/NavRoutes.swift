//
//  NavRoutes.swift
//  PingPong
//
//  Created by  admin on 08.11.2023.
//

import Combine

enum NavRoutes {
    case mainView, levelView, gameView, settingsView, storeView
}

final class RoutesObserver: ObservableObject {
    @Published var currentRoute: NavRoutes = .mainView
    
    
}
