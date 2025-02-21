//
//  DefaultButton.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 27.12.2024.
//

import SwiftUI

struct DefaultButton: View {
    let border: Color
    let fill: Color
    let action: ()->Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 0) {
                Spacer().frame(width: CST.offset)
                RoundedRectangle(cornerRadius: CST.radius)
                    .stroke(border)
                    .fill(fill)
                    .frame(height: CST.height)
                Spacer().frame(width: CST.offset)
            }
        }
        .buttonStyle(.plain)
    }
    
    private struct CST {
        static let offset: CGFloat = 30
        static let radius: CGFloat = 40
        static let height: CGFloat = 50
    }
}


#Preview {
    DefaultButton(border: .blue, fill: .gray, action: {} )
}
