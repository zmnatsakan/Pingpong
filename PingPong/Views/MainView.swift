//
//  MainView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink {
                    LevelsView(isGame: true, isFreePlay: false)
                } label: {
                    Text("Play")
                        .foregroundStyle(.white)
                        .font(.largeTitle.bold())
                        .padding()
                        .frame(width: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundStyle(.blue)
                        )
                }
                NavigationLink {
                    LevelsView()
                } label: {
                    Text("Select level")
                        .foregroundStyle(.white)
                        .font(.largeTitle.bold())
                        .padding()
                        .frame(width: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundStyle(.blue)
                        )
                }
                
                NavigationLink {
                    SettingsView()
                } label: {
                    Text("Settings")
                        .foregroundStyle(.white)
                        .font(.largeTitle.bold())
                        .padding()
                        .frame(width: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundStyle(.blue)
                        )
                }
            } //VSTACK
            .navigationTitle("Main View")
        } //NAVIGATIONSTACK
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
