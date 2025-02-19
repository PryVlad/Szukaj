//
//  SliderOfOptions.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 04.01.2025.
//

import SwiftUI

struct SliderOfOptions<T: sliderEnum>: View {
    let isHighlightOn: Bool
    let enumValNow: T
    let namespace: Namespace.ID
    let tapFunc: (_ enumCase: T) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 0) {
                ForEach(T.allCases) { elem in
                    TabView(activeTab: enumValNow,
                            selfTab: elem,
                            namespace: namespace,
                            visible: isHighlightOn)
                    .onTapGesture {
                        withAnimation(.spring) {
                            tapFunc(elem)
                        }
                    }
                }
            }
            Self.drawRect(height: 1, opacity: 0.2)
        }
    }
    
    static private func drawRect(
        height: CGFloat, opacity: CGFloat
    ) -> some View {
        Rectangle()
            .frame(height: height)
            .foregroundStyle(Szukaj.color.opacity(opacity))
    }
    
    private struct TabView<ENUM: sliderEnum>: View {
        let activeTab: ENUM
        let selfTab: T
        let namespace: Namespace.ID
        let visible: Bool
        
        var body: some View {
            HStack(spacing: 0) {
                Spacer().frame(width: CST.spacing)
                Label(selfTab.text, systemImage: selfTab.sysImg)
                    .font(.title3).fontWeight(.regular)
                    .foregroundStyle(tabColor)
                Spacer().frame(width: CST.spacing)
            }
            .padding(.top)
            .overlay(alignment: .bottom) {
                if visible && selfTab.text == activeTab.text {
                    SliderOfOptions.drawRect(
                        height: CST.activeLineSize,
                        opacity: 1)
                    .offset(y: CST.offsetUnderline)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace.self,
                                               properties: .frame)
                } else {
                    Color.clear.frame(height: CST.activeLineSize)
                }
            }
            .animation(.spring, value: self.activeTab)
        }
        
        private var tabColor: Color {
            visible && selfTab.text == activeTab.text
                             ? Szukaj.color
                             : .gray
        }
    }
}

fileprivate struct CST {
    static let offsetUnderline: CGFloat = 14
    static let spacing: CGFloat = 24
    static let activeLineSize: CGFloat = 2
}
