//
//  SliderOfOptions.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 04.01.2025.
//

import SwiftUI

struct SliderOfOptions<T: sliderEnum>: View {
    @EnvironmentObject private var app: Szukaj
    
    @Binding var isHighlightOn: Bool
    @Binding var enumValNow: T
    let namespace: Namespace.ID
    let tapFunc: () -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 0) {
                ForEach(T.allCases) { elem in
                    TabView(activeTab: $app.filter.bigSelectedEnumValue,
                                selfTab: elem,
                                namespace: namespace,
                                visible: $isHighlightOn.wrappedValue)
                    .onTapGesture {
                        if $enumValNow.wrappedValue == elem {
                            isHighlightOn.toggle()
                        } else {
                            isHighlightOn = true
                        }
                        enumValNow = elem
                        tapFunc()
                    }
                }
            }
            Self.drawRect(height: 1, opacity: 0.2)
        }
    }
    
    static private func drawRect(height: CGFloat, opacity: CGFloat
    ) -> some View {
        Rectangle()
            .frame(height: height)
            .foregroundStyle(Szukaj.color.opacity(opacity))
    }
    
    private struct TabView<ENUM: sliderEnum>: View {
        @Binding var activeTab: ENUM
        let selfTab: T
        let namespace: Namespace.ID
        let visible: Bool
        
        var body: some View {
            HStack(spacing: 0) {
                Spacer().frame(width: CST.spacing)
                Label(selfTab.text, systemImage: selfTab.sysImg)
                    .font(.title3).fontWeight(.regular)
                    .foregroundStyle(visible && selfTab.text == activeTab.text
                                     ? Szukaj.color
                                     : .gray)
                Spacer().frame(width: CST.spacing)
            }
            .padding(.top)
            .overlay(alignment: .bottom) {
                if visible && selfTab.text == activeTab.text {
                    SliderOfOptions.drawRect(height: CST.activeLineSize,
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
        
        private struct CST {
            static var offsetUnderline: CGFloat { 14 }
            static var spacing: CGFloat { 24 }
            static var activeLineSize: CGFloat { 2 }
        }
    }
}
