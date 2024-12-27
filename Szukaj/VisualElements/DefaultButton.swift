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
                Spacer().frame(width: 30)
                RoundedRectangle(cornerRadius: 40)
                    .stroke(border)
                    .fill(fill)
                    .frame(height: 50)
                Spacer().frame(width: 30)
            }
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    DefaultButton(border: .blue, fill: .gray, action: {} )
}
