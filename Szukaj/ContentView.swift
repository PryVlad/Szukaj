//
//  ContentView.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 15.12.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var app: Szukaj
    
    var body: some View {
        VStack {
            Logo("szukaj")
                .padding(CST.padding)
            printOffers
            Spacer()
        }
    }
    
//    TotalOffers(amount: app.offers)
    var printOffers: some View {
        Rectangle().frame(width: .infinity, height: CST.Offers.height)
            .foregroundStyle(.gray.opacity(CST.Offers.opacity))
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
    ContentView(app: Szukaj())
}
