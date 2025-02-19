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
    
    private let temp = 1/1.38
    
    var body: some View {
        VStack(spacing: 0) {
            if app.filter.isTapTextSearch {
                searchDecoy(namespase: search, id: "box")
                    .padding(.vertical)
                Color.clear
                    .aspectRatio(temp, contentMode: .fill)
                topButton
                    .padding(.bottom)
                    .matchedGeometryEffect(id: "press", in: search)
            } else {
                scroll
                    .transition(.standartPush())
                searchDecoy(namespase: search, id: "box")
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
            withAnimation(.bouncy) {
                app.filter.isTapTextSearch.toggle()
                app.allowTotalOffersRoll = false
            }
        })
        .overlay {
            Text(CST.Button.strTop)
                .font(.title2).fontWeight(.bold)
                .foregroundStyle(.white)
        }
    }
    
    private func searchDecoy(
        namespase: Namespace.ID, id: String
    ) -> some View {
        HStack(spacing: 0) {
            Spacer().frame(width: 30)
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.gray)
                .frame(height: 50)
                .foregroundStyle(.white)
                .overlay(alignment: .leading) {
                    Text("WIP")
                }
                .matchedGeometryEffect(id: id, in: tabs)
            Spacer().frame(width: 30)
        }
    }
        
    private var scroll: some View {
        SliderOfOptions(isHighlightOn: app.filter.isBigFilterActiveTab,
                        enumValNow: app.filter.bigSelectedEnumValue,
                        namespace: tabs,
                        tapFunc: { enumCase in app.filter.updateBigFilter(enumCase)
        })
        .padding(.leading, CST.spacingScroll)
    }
    
    private var bgColor: Color {
        scheme == .light ? .white : .black
    }
    
    private struct CST {
        static let spacingScroll: CGFloat = 24

        struct Button {
            static let offset: CGFloat = 30
            static let radius: CGFloat = 40
            static let height: CGFloat = 50
            static let strTop = "🎲  Try to find"
            static let strBot = "More options  "
        }
    }
}
