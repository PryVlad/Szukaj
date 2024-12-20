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
            Color.BG.opacity(CST.OffersCount.opacity)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        bgColor.ignoresSafeArea()
                        Logo("szukaj").padding(CST.paddingLogo)
                    }
                    printOffersNum
                    StartFilterBig()
                }
                dayText
                printOffers
                }
            }
        }
    
    private var printOffers: some View {
        VStack(spacing: CST.spacingOffer) {
            ForEach(app.getOffers) { offer in
                OfferView(offer: offer)
            }
        }
    }
    
    private var dayText: some View {
        VStack(spacing: 0) {
            Text("Strefa ofert")
                .font(.largeTitle).fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(CST.quote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
        }
        .padding()
    }
    
//    var filters: some View {
//        Button {
//            withAnimation {
//                if app.activeFilters.isEmpty {
//                    app.activeFilters.append(.cv(.szybko))
//                } else {
//                    app.activeFilters.removeAll()
//                }
//            }
//        } label: {
//            ZStack {
//                Rectangle().foregroundStyle(.white).frame(width: 200, height: 50).border(.black)
//                Label("filter WIP", systemImage: "rectangle.checkered")
//            }
//        }
//    }
    
    private var printOffersNum: some View {
        Color.clear
            .frame(height: CST.OffersCount.height)
            .overlay {
                TotalOffersIntended() // TotalOffers(amount: app.offers)
                .font(.system(size: CST.OffersCount.textSize,
                              weight: .semibold))
            }
    }
    
    private var bgColor: Color {
        scheme == .light ? .white : .black
    }
    
    private struct CST {
        static let paddingLogo: CGFloat = 14
        static let spacingOffer: CGFloat = 30
        static let quote = SzukajRoot.ConfuciusQuote.randomElement()!
        
        struct OffersCount {
            static let height: CGFloat = 70
            static let textSize: CGFloat = 24
            static let opacity = 0.5
        }
    }
}
