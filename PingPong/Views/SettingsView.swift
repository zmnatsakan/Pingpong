//
//  SettingsView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 25.10.23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            ScreenTitle(title: "Settings", fontSize: 30)
            Toggle("Vibrations", isOn: HapticManager.shared.$isHavticOn)
            Button("Reset All") {
                UserDefaults.standard.resetDefaults()
            }
            Divider()
            
            Button("More") {
                
            }
            .buttonStyle(.bordered)
            
            Button("Privacy policy") {
                
            }
            .buttonStyle(.bordered)
            
            Button("Feedback") {
                
            }
            .buttonStyle(.bordered)
            
            Button("About") {
                
            }
            .buttonStyle(.bordered)
            
            Button("Help") {
                
            }
            .buttonStyle(.bordered)
            
            Spacer()
        } //VSTACK
        .padding()
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
