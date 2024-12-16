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
            TotalOffers(amount: 9020406034543)
                .font(.title)
            TotalOffersIntended(amount: 9020406034543,
                                orderDelay: $app.orderDelay)
                .font(.title)
        }
    }
}



#Preview {
    ContentView(app: Szukaj())
}
