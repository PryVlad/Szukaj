//
//  BottomNav.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 17.12.2024.
//

import SwiftUI

struct BottomNavigation: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            BotElement(text: "Start", sysName: "house")
            BotElement(text: "Noted", sysName: "star.square")
            BotElement(text: "Konto", sysName: "person.circle")
            BotElement(text: "Menu", sysName: "list.bullet")
        }
        .padding(.top, -8)
    }
    
    struct BotElement: View {
        @EnvironmentObject var app: Szukaj
        
        let text: String
        let sysName: String
        
        var body: some View {
            Rectangle()
                .ignoresSafeArea()
                .frame(height: CST.rectH)
                .foregroundStyle(app.activeNav == text
                                 ? CST.activeColor
                                 : .clear)
                .overlay(alignment: .bottom) {
                    VStack(spacing: 0) {
                        Image(systemName: sysName)
                        Text(text)
                    }
                    .font(.title2)
                    .foregroundStyle(app.activeNav == text
                                     ? CST.activeIcon
                                     : .gray)
                }
                .onTapGesture {
                    app.activeNav = text
                }
        }
    }
    
    private struct CST {
        static let activeColor: Color = .blue.mix(with: .white, by: 0.6)
        static let rectH: CGFloat = 80
        static let activeIcon: Color = .blue.mix(with: .black, by: 0.3)
    }
}

#Preview {
    BottomNavigation()
}
