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
            Rectangle()
                .foregroundStyle(.BG.opacity(CST.OffersCount.opacity))
                .ignoresSafeArea()
            ScrollView {
                VStack {
                    ZStack {
                        Rectangle().foregroundStyle(.white)
                            .ignoresSafeArea()
                        Logo("szukaj")
                            .padding(CST.paddingLogo)
                    }
                    printOffers
                    StartFilterBig()
                    Text("Oferty dnia")
                        .padding(.vertical)
                }
                VStack(spacing: CST.spacingOffer) {
                    ForEach(app.getOffers) { offer in
                        OfferView(offer: offer)
                    }
                }
                .padding(.top, -8)
            }
        }
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
    
    var printOffers: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .frame(height: CST.OffersCount.height)
            .overlay {
                TotalOffersIntended() // TotalOffers(amount: app.offers)
                    .environmentObject(app)
                .font(.system(size: CST.OffersCount.textSize, weight: .semibold))
            }
    }
    
    private struct CST {
        static let paddingLogo: CGFloat = 10
        static let spacingOffer: CGFloat = 30
        
        struct OffersCount {
            static let height: CGFloat = 70
            static let textSize: CGFloat = 24
            static let opacity = 0.5
        }
    }
}
