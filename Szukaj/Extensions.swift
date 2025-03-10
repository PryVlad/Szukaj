//
//  Extensions.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 03.01.2025.
//

import SwiftUI

extension SzukajRoot.Offer.poziomStanowiska {
    func isFound(in source: Szukaj) -> Bool {
        for i in source.filter.active {
            if case let .stan(wrapper) = i {
                if wrapper.wrapper.storage.values.contains(self) {
                    return true
                }
            }
        }
        return false
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

extension Color {
    static func random() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}

extension AnyTransition {
    static func standartPush(_ reversed: Bool? = false) -> AnyTransition {
        .asymmetric(insertion: .push(from: reversed! ? .bottom : .top),
                    removal: .push(from: reversed! ? .top : .bottom))
    }
}
