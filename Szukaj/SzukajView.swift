//
//  ContentView.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 15.12.2024.
//

import SwiftUI

struct SzukajView: View {
    @ObservedObject var app: Szukaj
    
    var body: some View { // who needs TabView and NavStack?
        VStack(spacing: 0) {
            content
                .background(Szukaj.colorBG)
                .sheet(isPresented: $app.isOpenFullSearch) {
                    FullFilterView()
                }
        }
        .overlay {
            GeometryReader { reader in
                Szukaj.color
                    .frame(height: reader.safeAreaInsets.top, alignment: .top)
                    .ignoresSafeArea()
            }
            BottomNavigation()
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .environmentObject(app)
    }
    
    @ViewBuilder
    var content: some View {
        switch app.activeNav {
        case .start:
            Start()
        case .noted:
            Noted()
        case .konto:
            Noted()
        case .menu:
            Noted()
        }
    }
}



#Preview {
    SzukajView(app: Szukaj())
}
