//
//  PingPongApp.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SwiftUI

@main
struct PingPongApp: App {
    @ObservedObject var observer = RoutesObserver()
    var body: some Scene {
        WindowGroup {
            MainView().environmentObject(observer)
        }
    }
}
