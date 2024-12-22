//
//  Start.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 18.12.2024.
//

import SwiftUI

struct Start: View {
    @EnvironmentObject var app: Szukaj
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        ZStack {
            Color.BG.opacity(CST.NumOffers.opacity)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        bgColor.ignoresSafeArea()
                        Logo(CST.logoText).padding(CST.paddingLogo)
                    }
                    printNumOffers
                    StartFilterBig()
                }
                dayText
                printOffers
                }
            }
        }
    
    private var printOffers: some View {
        LazyVStack(spacing: CST.spacingOffer) {
            ForEach(app.getOffers) { offer in
                OfferView(offer: offer)
            }
            Color.clear
                .frame(height: 1)
                .onAppear {
                    app.reachBottom()
                }
        }
    }
    
    private var dayText: some View {
        VStack(spacing: 0) {
            Text(CST.dayText)
                .font(.largeTitle).fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(CST.quote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
        }
        .padding()
    }
    
    private var printNumOffers: some View {
        Color.clear
            .frame(height: CST.NumOffers.height)
            .overlay {
                TotalOffersIntended() // TotalOffers(amount: app.offers)
                .font(.system(size: CST.NumOffers.textSize,
                              weight: .semibold))
            }
    }
    
    private var bgColor: Color {
        scheme == .light ? .white : .black
    }
    
    private struct CST {
        static let paddingLogo: CGFloat = 14
        static let spacingOffer: CGFloat = 30
        static let quote = Szukaj.ConfuciusQuote.randomElement()!
        static let dayText = "Strefa ofert"
        static let logoText = "szukaj"
        
        struct NumOffers {
            static let height: CGFloat = 70
            static let textSize: CGFloat = 24
            static let opacity = 0.5
        }
    }
}
