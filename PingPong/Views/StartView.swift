//
//  StartViewq.swift
//  PingPong
//
//  Created by  admin on 08.11.2023.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var observer: RoutesObserver
    @State var transitionProgress = 0.2
    
    var body: some View {
        ZStack {
            Group {
                Color(red: 0.1, green: 0.14, blue: 0.18)
                Image("menuBG")
                    .resizable()
                    .scaledToFill()
            }
            .ignoresSafeArea()
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .background {
                    Image("circles")
                        .resizable()
                        .frame(width: 800, height: 800)
                        .scaleEffect(transitionProgress)
                        .opacity(transitionProgress)
                        .onAppear {
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut(duration: 2)) {
                                    transitionProgress = 1
                                }
                            }
                        }
                }
            
            VStack(spacing: 0) {
                CoinLabel()
                    .padding(.vertical, 80)
                    .padding(.horizontal, 20)
                Spacer()
                VStack {
                    Button(action: {
                        observer.currentRoute = .gameView
                    }, label: {
                        Image("buttons/play")
                            .resizable()
                            .scaledToFit()
                    })
                    
                    Button(action: {
                        observer.currentRoute = .levelView
                    }, label: {
                        Image("buttons/selectLevel")
                            .resizable()
                            .scaledToFit()
                    })
                    
                    Button(action: {
                        observer.currentRoute = .storeView
                    }, label: {
                        Image("buttons/store")
                            .resizable()
                            .scaledToFit()
                    })
                    
                    Button(action: {
                        observer.currentRoute = .settingsView
                    }, label: {
                        Image("buttons/settings")
                            .resizable()
                            .scaledToFit()
                    })
                } //VSTACK
                .padding()
                .padding(.bottom, 90)
            } //VSTACK
        } //ZSTACK
    }
}

#Preview {
    StartView()
}
