//
//  Start.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 18.12.2024.
//

import SwiftUI

struct Start: View {
    @EnvironmentObject var app: Szukaj
    
    var body: some View {
        ZStack {
            Rectangle().foregroundStyle(.BG.opacity(CST.Offers.opacity))
            ScrollView {
                VStack {
                    ZStack {
                        Rectangle().foregroundStyle(.white)
                        Logo("szukaj")
                            .padding(CST.paddingLogo)
                    }
                    printOffers
                }
                VStack(spacing: CST.spacingOffer) {
                    OfferView(temp: .niewymagane)
                    OfferView(temp: .szybko)
                    OfferView(temp: .szybko)
                    OfferView(temp: .niewymagane)
                    OfferView(temp: .szybko)
                }
                .padding(.top, -8)
            }
        }
    }
    
    var printOffers: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .frame(height: CST.Offers.height)
            .overlay {
                TotalOffersIntended() // TotalOffers(amount: app.offers)
                    .environmentObject(app)
                .font(.system(size: CST.Offers.textSize, weight: .semibold))
            }
    }
    
    private struct CST {
        static let paddingLogo: CGFloat = 10
        static let spacingOffer: CGFloat = 30
        
        struct Offers {
            static let height: CGFloat = 70
            static let textSize: CGFloat = 24
            static let opacity = 0.5
        }
    }
}
