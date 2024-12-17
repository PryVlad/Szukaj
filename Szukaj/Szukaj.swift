//
//  ViewModel.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 16.12.2024.
//

import SwiftUI

class Szukaj: ObservableObject {
    @Published var szukaj = SzukajRoot()
    @Published var activeNav = "Start"
    
    var orderDelay: TimeInterval = 0
    var offers: Int { szukaj.fakeOffersCount }
    
}
