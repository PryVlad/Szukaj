//
//  Start.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 18.12.2024.
//

import SwiftUI

struct Start: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var app: Szukaj
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if !app.filter.isTapTextSearch {
                    Logo.standart(bg: bgColor)
                    printNumOffers
                }
                StartFilterBig()
            }
            if !app.filter.isTapTextSearch {
                dayText
                StackOffers(source: .all)
            }
        }
        .onDisappear {
            app.allowTotalOffersRoll = true
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
        static let quote = Szukaj.ConfuciusQuote.randomElement()!
        static let dayText = "Strefa ofert"
        
        struct NumOffers {
            static let height: CGFloat = 70
            static let textSize: CGFloat = 24
            static let opacity = 0.5
        }
    }
}
