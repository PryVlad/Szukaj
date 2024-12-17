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
                Rectangle().frame(height: 500).foregroundStyle(.gray)
                Rectangle().frame(height: 500).foregroundStyle(.black)
                Rectangle().frame(height: 500).foregroundStyle(.gray)
            }
            .padding(.top, -8) // thanks apple
        }
        BottomNavigation()
            .environmentObject(app)
    }
    
//    TotalOffers(amount: app.offers)
    var printOffers: some View {
        Rectangle()
            .foregroundStyle(.gray.opacity(CST.Offers.opacity))
            .frame(height: CST.Offers.height)
            .overlay {
                TotalOffersIntended(amount: app.offers,
                                    orderDelay: $app.orderDelay)
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
