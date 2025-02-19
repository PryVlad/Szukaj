//
//  FFSelectSection.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 19.02.2025.
//

import SwiftUI

struct FFSelectSection<T: ConfirmFEStorage>: View {
    @EnvironmentObject private var app: Szukaj
    @State private var isHidden = false
    
    @State var accumulator: T
    @Binding var isTapButton: Bool
    
    let label: String
    let sysImg: String
    
    var body: some View {
        topLabel(label, sysImg: sysImg)
            .background(background)
            .padding(.bottom, isHidden ? 0 : CST.Padding.header)
            .onChange(of: isTapButton) {
                if isTapButton {
                    accumulator.update(app)
                }
            }
        VStack(spacing: 0) {
            if !isHidden {
                VStack(spacing: 0) {
                    ForEach(accumulator.wrapper.allCases, id: \.self) { val in
                        FFRowView(accum: $accumulator, elem: val)
                            .padding([.horizontal, .bottom],
                                     CST.Padding.element)
                    }
                }
            } else {
                Color.clear.frame(height: 1)
            }
        }
        .transition(.standartPush())
        .clipped()
    }
    
    private func topLabel(_ text: String, sysImg: String) -> some View {
        HStack(spacing: 0) {
            Label(text, systemImage: sysImg)
                .font(.title2).fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Image(systemName: isHidden ? "chevron.down" : "chevron.up")
                .padding()
        }
    }
    
    private var background: some View {
        HStack {
            Spacer().frame(width: CST.labelRectSpacingH)
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Szukaj.colorBG)
            Spacer().frame(width: CST.labelRectSpacingH)
        }
        .onTapGesture {
            withAnimation(.spring) {
                isHidden.toggle()
            }
        }
    }
}

fileprivate struct CST {
    static let labelRectSpacingH: CGFloat = 6
    
    struct Padding {
        static let header: CGFloat = 12
        static let element: CGFloat = 10
    }
}

