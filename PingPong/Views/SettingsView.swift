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
            Toggle("Vibrations", isOn: HapticManager.shared.$isHavticOn)
            Spacer()
        } //VSTACK
        .padding()
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
