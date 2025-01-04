//
//  FullFilterRowView.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 03.01.2025.
//

import SwiftUI

struct FFRowView: View {
    @EnvironmentObject private var app: Szukaj
    @State var isSelected = false

    @Binding var accum: FieldStorage
    let elem: FieldElement
    
    var body: some View {
        HStack(spacing: 0) {
            checkmark
                .padding(CST.cBox.padding)
            Text(elem.rawValue)
                .font(.title2)
            Spacer()
        }
        .onTapGesture {
            tap
        }
        .onAppear {
            appear
        }
    }
    
    private var checkmark: some View {
        ZStack {
            Rectangle()
                .strokeBorder(Szukaj.color, lineWidth: CST.cBox.lineWidth)
                .fill(isSelected ? Szukaj.color : .clear)
                .frame(width: CST.cBox.size, height: CST.cBox.size,
                       alignment: .leading)
                .overlay {
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                    }
                }
        }
    }
    
    private var tap: Void {
        isSelected.toggle()
        if accum.contains(elem) {
            accum.remove(elem)
        } else {
            accum.add(elem)
        }
    }
    
    private var appear: Void {
        for i in app.filter.active {
            if case let .stan(wrapper) = i {
                if wrapper.value.contains(where: {
                    $0.rawValue == elem.rawValue })
                {
                    isSelected = true
                }
            }
        }
    }
    
    private struct CST {
        struct cBox {
            static let size: CGFloat = 22
            static let lineWidth: CGFloat = 2
            static let padding: CGFloat = 12
        }
    }
}
