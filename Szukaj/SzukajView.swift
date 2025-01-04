//
//  ContentView.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 15.12.2024.
//

import SwiftUI

struct SzukajView: View {
    @ObservedObject var app: Szukaj
    @State private var isFilterApply = false
    
    var body: some View { // who needs TabView and NavStack?
        VStack(spacing: 0) {
            content
                .background(Szukaj.colorBG)
                .sheet(isPresented: $app.filter.isOpenFullSearch) {
                    FullFilterView(filterState: $isFilterApply)
                }
            BottomNavigation()
        }
        .overlay {
            GeometryReader { reader in
                Szukaj.color
                    .frame(height: reader.safeAreaInsets.top, alignment: .top)
                    .ignoresSafeArea()
            }
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
