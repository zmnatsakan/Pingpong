//
//  AboutView.swift
//  PingPong
//
//  Created by  admin on 09.11.2023.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                    }
                    .tint(.white)
                    Spacer()
                }
                .padding(40)
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                }
                .frame(width: 100, height: 100)
                .padding(.top, 40)
                
                Text(Bundle.main.displayName ?? "123")
                    .font(.title)
                Text("Version: " + (Bundle.main.releaseVersionNumber ?? "123"))
                Text("Build: " + (Bundle.main.buildVersionNumber ?? "123"))
                
                Divider()
                    .background(.white)
                    .padding()
                
                Text("Email: (AppStorageManager.email)")
                
                Spacer()
                
            } //VSTACK
        } //ZSTACK
    }
}

#Preview {
    AboutView()
}
