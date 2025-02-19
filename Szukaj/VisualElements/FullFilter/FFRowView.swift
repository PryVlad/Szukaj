//
//  FullFilterRowView.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 03.01.2025.
//

import SwiftUI

struct FFRowView<T: ConfirmFEStorage>: View {
    @EnvironmentObject private var app: Szukaj
    @State var isSelected = false

    @Binding var accum: T
    let elem: T.WRAP.VAL.FE
    
    var body: some View {
        HStack(spacing: 0) {
            checkmark
                .padding(CST.cBox.padding)
            Text(elem.rawValue)
                .font(.title2)
            Spacer()
        }
        .onTapGesture {
            addToAccAndToggle
        }
        .onAppear {
            if elem.isFound(in: app) {
                isSelected = true
                accum.wrapper.add(elem)
            }
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
    
    private var addToAccAndToggle: Void {
        isSelected.toggle()

        if isSelected {
            accum.wrapper.add(elem)
        } else {
            accum.wrapper.remove(elem)
        }
    }
}

fileprivate struct CST {
    struct cBox {
        static let size: CGFloat = 22
        static let lineWidth: CGFloat = 2
        static let padding: CGFloat = 12
    }
}
