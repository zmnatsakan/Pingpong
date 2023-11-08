//
//  ScreenTitle.swift
//  PingPong
//
//  Created by  admin on 08.11.2023.
//

import SwiftUI

struct ScreenTitle: View {
    let title: String
    var fontSize: CGFloat = 36
    
    @EnvironmentObject var observer: RoutesObserver
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    observer.currentRoute = .mainView
                }
            } label: {
                Image("buttons/navigation/home")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            .padding(.horizontal)
            
            Text(title)
                .font(.custom("HalvarBreit-Blk", size: fontSize))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            Spacer()
        }
    }
}
