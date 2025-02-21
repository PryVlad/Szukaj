//
//  StartFilterBig.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 20.12.2024.
//

import SwiftUI

struct StartFilterBig: View {
    @EnvironmentObject private var app: Szukaj
    @Environment(\.colorScheme) private var scheme
    @Namespace private var tabs
    @Namespace private var search
    
    private let temp = CST.Rect.h*3.8
    
    var body: some View {
        VStack(spacing: 0) {
            if app.filter.isTapTextSearch {
                Image(systemName: "xmark")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding() // [.horizontal, .top]
                filterByText(namespase: search, id: "box")
                    .padding(.vertical)
                Color.clear
                    .frame(height: temp)
                topButton
                    .padding(.bottom)
                    .matchedGeometryEffect(id: "press", in: search)
            } else {
                scrollTabs
                    .transition(.standartPush())
                filterByText(namespase: search, id: "box")
                    .padding(.vertical)
                Group {
                    topButton
                        .padding(.top)
                        .matchedGeometryEffect(id: "press", in: search)
                    botButton
                        .transition(.standartPush(true))
                        .padding(.bottom)
                }
                .padding(.bottom)
            }
        }
        .background(bgColor)
        .onTapGesture { focusDisable() }
    }
    
    private func focusDisable() {
        withAnimation(.bouncy) {
            app.filter.isTapTextSearch = false
            focus = false
        }
    }
    
    private var botButton: some View {
        DefaultButton(border: Szukaj.color, fill: bgColor,
                      action: {
            app.filter.isOpenFullSearch = true
        })
        .overlay {
            HStack(spacing: 0) {
                Text(CST.Button.strBot)
                Image(systemName: "arrowshape.right")
            }
                .font(.title2).fontWeight(.semibold)
                .foregroundStyle(Szukaj.color)
        }
    }
    
    private var topButton: some View {
        DefaultButton(border: .clear, fill: Szukaj.color, action: {
            // send to $app.filter.textInput
        })
        .overlay {
            Text(CST.Button.strTop)
                .font(.title2).fontWeight(.bold)
                .foregroundStyle(.white)
        }
    }
    
    @FocusState private var focus: Bool
    @State private var tempUserInput = ""
    
    private func filterByText(
        namespase: Namespace.ID, id: String
    ) -> some View {
        HStack(spacing: 0) {
            Spacer().frame(width: CST.Spacing.standart)
            RoundedRectangle(cornerRadius: CST.Rect.cornerR)
                .strokeBorder(.gray)
                .frame(height: CST.Rect.h)
                .foregroundStyle(.white)
                .overlay(alignment: .leading) {
                    TextField(" Type here", text: $tempUserInput)
                        .padding(.horizontal, CST.paddingH)
                        .focused($focus)
                }
                .matchedGeometryEffect(id: id, in: tabs)
                .onChange(of: focus) { focusStateChange() }
            Spacer().frame(width: CST.Spacing.standart)
        }
    }
    
    private func focusStateChange() {
        if focus && !app.filter.isTapTextSearch {
            withAnimation(.bouncy) {
                app.filter.isTapTextSearch = true
                app.allowTotalOffersRoll = false
            }
        } else if app.filter.isTapTextSearch {
            focus = true
        }
    }
        
    private var scrollTabs: some View {
        SliderOfOptions(isHighlightOn: app.filter.isBigFilterActiveTab,
                        enumValNow: app.filter.bigSelectedEnumValue,
                        namespace: tabs,
                        tapFunc: { enumCase in app.filter.updateBigFilter(enumCase)
        })
        .padding(.leading, CST.Spacing.scroll)
    }
    
    private var bgColor: Color {
        scheme == .light ? .white : .black
    }
    
    private struct CST {
        static let paddingH: CGFloat = 10
        
        struct Rect {
            static let h: CGFloat = 50
            static let cornerR: CGFloat = 50
        }
        struct Spacing {
            static let scroll: CGFloat = 24
            static let standart: CGFloat = 30
        }
        struct Button {
            static let strTop = "🎲  Try to find"
            static let strBot = "More options  "
        }
    }
}
