//
//  ViewModel.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 16.12.2024.
//

import SwiftUI

class Szukaj: ObservableObject {
    @Published var temp = 0
    
    var orderDelay: TimeInterval = 0
    var offers: Int { 9020406034543 }
    
}
