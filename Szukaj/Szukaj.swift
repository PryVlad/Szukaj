//
//  ViewModel.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 16.12.2024.
//

import SwiftUI

class Szukaj: ObservableObject {
    @Published var szukaj = SzukajRoot()
    @Published var activeNav: NavName = .start
    @Published var activeFilters: [SzukajRoot.Fields] = []
    
    var orderDelay: TimeInterval = 0
    
    var numOffers: Int {
        get { szukaj.fakeOffersCount }
        set(newValue) { szukaj.fakeOffersCount = newValue }
    }
    var getOffers: [SzukajRoot.Offer] {
        let base = OfferCVFilter(offerFilter: OfferBaseFilter())
        return base.filter(offers: SzukajRoot.mockData, by: activeFilters)
    }
    
    static let color: Color = .blue.mix(with: .black, by: 0.3)
    
    enum NavName: CaseIterable, Identifiable {
        case start, noted, konto, menu
        
        var id: Self {
            self
        }
        
        static func getStr(_ nav: NavName) -> String {
            switch nav {
            case .start:
                "Start"
            case .noted:
                "Noted"
            case .konto:
                "Konto"
            case .menu:
                "Menu"
            }
        }
        
        static func getIcon(_ nav: NavName) -> String {
            switch nav {
            case .start:
                "house"
            case .noted:
                "star.square"
            case .konto:
                "person.circle"
            case .menu:
                "list.bullet"
            }
        }
    }
}
