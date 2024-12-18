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
    
    var orderDelay: TimeInterval = 0
    var offers: Int {
        get { szukaj.fakeOffersCount }
        set(newValue) { szukaj.fakeOffersCount = newValue }
    }
    
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
