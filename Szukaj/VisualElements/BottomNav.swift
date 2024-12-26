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
            ForEach(Szukaj.NavName.allCases) { name in
                BotElement(name: name)
            }
        }
        .padding(.top, -8)
    }
    
    private struct BotElement: View {
        @EnvironmentObject private var app: Szukaj
        @Environment(\.colorScheme) private var scheme
        typealias nav = Szukaj.NavName
        
        let name: nav
        
        var body: some View {
            Rectangle()
                .ignoresSafeArea()
                .frame(height: CST.rectH)
                .foregroundStyle(app.activeNav == name
                                 ? CST.activeColor
                                 : bgColor)
                .overlay(alignment: .bottom) {
                    VStack(spacing: 0) {
                        Image(systemName: nav.getIcon(name))
                        Text(nav.getStr(name))
                    }
                    .font(.title2)
                    .foregroundStyle(app.activeNav == name
                                     ? Szukaj.color
                                     : .gray)
                }
                .onTapGesture {
                    app.activeNav = name
                }
        }
        
        private var bgColor: Color {
            scheme == .light ? .white : .black
        }
    }
    
    private struct CST {
        static let activeColor: Color = .blue.mix(with: .white, by: 0.6)
        static let rectH: CGFloat = 80
    }
}
