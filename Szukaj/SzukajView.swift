//
//  ContentView.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 15.12.2024.
//

import SwiftUI

struct SzukajView: View {
    @ObservedObject var app: Szukaj
    
    var body: some View {
        ScrollView {
            VStack {
                Logo("szukaj")
                    .padding(CST.padding)
                printOffers
            }
            VStack(spacing: 0) {
                Button {
                    app.offers-=12345
                } label: {
                    Text("minus")
                }
                Rectangle().frame(height: 500).foregroundStyle(.gray)
                Rectangle().frame(height: 500).foregroundStyle(.black)
                Rectangle().frame(height: 500).foregroundStyle(.gray)
            }
            .padding(.top, -8)
        }
        BottomNavigation()
            .environmentObject(app)
    }
    
    var printOffers: some View {
        Rectangle()
            .foregroundStyle(.gray.opacity(CST.Offers.opacity))
            .frame(height: CST.Offers.height)
            .overlay {
                TotalOffersIntended() // TotalOffers(amount: app.offers)
                    .environmentObject(app)
                .font(.system(size: CST.Offers.textSize, weight: .semibold))
            }
    }
    
    private struct CST {
        static let padding = 10.0
        struct Offers {
            static let height: CGFloat = 70
            static let textSize: CGFloat = 24
            static let opacity = 0.2
        }
    }
}



#Preview {
    SzukajView(app: Szukaj())
}
