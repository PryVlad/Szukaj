//
//  StackOffers.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 23.12.2024.
//

import SwiftUI

struct StackOffers: View {
    @EnvironmentObject private var app: Szukaj
    static private let spacing: CGFloat = 30
    
    let source: Source
    
    var body: some View {
        LazyVStack(spacing: Self.spacing) {
            ForEach(get(source)) { offer in
                OfferView(offer: offer)
            }
            Color.clear
                .frame(height: 1)
                .onAppear {
                    app.loadMore()
                }
        }
        .onAppear {
            app.visibleStars = 0
        }
    }
    
    private func get(_ array: Source) -> [SzukajRoot.Offer] {
        switch array {
        case .noted:
            return app.noted
        default:
            return app.getOffers
        }
    }
    
    enum Source {
        case all, noted
    }
}

//#Preview {
//    StackOffers()
//}
