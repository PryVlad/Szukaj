//
//  Noted.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 18.12.2024.
//

import SwiftUI

struct Noted: View {
    var body: some View {
        ScrollView {
            Logo.standart(bg: .white)
            StackOffers(source: .noted)
        }
    }
}

#Preview {
    Noted()
}
