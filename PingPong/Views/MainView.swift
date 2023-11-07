//
//  MainView.swift
//  PingPong
//
//  Created by Mnatsakan Work on 21.09.23.
//

import SwiftUI

struct MainView: View {
    @StateObject var storeSystem = StoreSystem()
    @State var transitionProgress = 0.2
    
    var body: some View {
        NavigationStack {
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
                
                VStack {
                    Spacer()
                    VStack {
                        NavigationLink {
                            LevelsView(isGame: true, isFreePlay: false)
                        } label: {
                            Image("buttons/play")
                                .resizable()
                                .scaledToFit()
                        }
                        
                        NavigationLink {
                            LevelsView(isGame: false)
                        } label: {
                            Image("buttons/selectLevel")
                                .resizable()
                                .scaledToFit()
                        }
                        
                        NavigationLink {
                            StoreView()
                        } label: {
                            Image("buttons/store")
                                .resizable()
                                .scaledToFit()
                        }
                        
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image("buttons/settings")
                                .resizable()
                                .scaledToFit()
                        }
                    } //VSTACK
                    .padding()
                    .padding(.bottom, 70)
                } //VSTACK
                
                VStack {
                    HStack {
                        Spacer()
                        HStack {
                            Text("\(storeSystem.storedCoins)")
                                .font(.custom("HalvarBreit-Blk", size: 30))
                                .foregroundStyle(.white)
                            Image("icons/coin")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding(50)
                    Spacer()
                }
            } //ZSTACK
        } //NAVIGATIONSTACK
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
