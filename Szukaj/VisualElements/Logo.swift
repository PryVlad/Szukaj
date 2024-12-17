//
//  Logo.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 17.12.2024.
//

import SwiftUI

struct Logo: View {
    let text: String
    let color: Color
    
    init(_ text: String, color: Color? = .blue.mix(with: .black, by: 0.4)) {
        self.text = text
        self.color = color!
    }
    
    var body: some View {
        Text("  \(text)  ")
            .foregroundStyle(.white)
            .background(Capsule().foregroundStyle(color))
            .font(.title)
    }
}
