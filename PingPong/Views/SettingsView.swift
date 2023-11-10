//
//  SettingsView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 25.10.23.
//

import SwiftUI

struct SettingsView: View {
    @State var privacyDisplayed = false
    @State var aboutDisplayed = false
    
    var body: some View {
        VStack {
            ScreenTitle(title: "Settings", fontSize: 30)
            Toggle(isOn: HapticManager.shared.$isHavticOn, label: {
                Image("buttons/settings/vibrations")
                    .resizable()
                    .scaledToFit()
                    .padding(.trailing, 50)
            })
            .padding(.trailing, 50)
            Button {
                UserDefaults.standard.resetDefaults()
            } label: {
                Image("buttons/settings/reset")
                    .resizable()
                    .scaledToFit()
            }
            
            Divider()
                .background(.white)
                .padding(.vertical)
            
            Button {
                privacyDisplayed.toggle()
            } label: {
                Image("buttons/settings/privacy")
                    .resizable()
                    .scaledToFit()
            }
            
            Button {
                // MARK: - TODO appid
                let link = "https://apps.apple.com/app/id\("")?action=write-review"
                if let url = URL(string: link) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Image("buttons/settings/feedback")
                    .resizable()
                    .scaledToFit()
            }
            
            Button {
                aboutDisplayed.toggle()
            } label: {
                Image("buttons/settings/about")
                    .resizable()
                    .scaledToFit()
            }
            
            Button {
                // MARK: - TODO email
                if let url = URL(string: "mailto:\("")") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Image("buttons/settings/help")
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
        } //VSTACK
        .padding()
        .navigationTitle("Settings")
        .background {
            Color.background.ignoresSafeArea()
        }
        .sheet(isPresented: $privacyDisplayed) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $aboutDisplayed) {
            AboutView()
        }
    }
}

#Preview {
    SettingsView()
}
