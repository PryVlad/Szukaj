//
//  BottomNav.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 17.12.2024.
//

import SwiftUI

struct BottomNavigation: View {
    @EnvironmentObject var app: Szukaj
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Szukaj.NavName.allCases) { name in
                BotElement(name: name)
            }
        }
        .padding(.top, -8)
    }
    
    struct BotElement: View {
        @EnvironmentObject var app: Szukaj
        typealias nav = Szukaj.NavName
        
        let name: nav
        
        var body: some View {
            Rectangle()
                .ignoresSafeArea()
                .frame(height: CST.rectH)
                .foregroundStyle(app.activeNav == name
                                 ? CST.activeColor
                                 : .clear)
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
    }
    
    private struct CST {
        static let activeColor: Color = .blue.mix(with: .white, by: 0.6)
        static let rectH: CGFloat = 80
    }
}
