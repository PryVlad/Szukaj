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
    
    var body: some View {
        VStack(spacing: 0) {
            if app.filter.isTapTextSearch != false {
                textFilterOn
            } else {
                textFilterOff
            }
        }
        .background(background)
    }
    
    private var background: some View {
        bgColor
            .onTapGesture {
                if app.filter.isTapTextSearch == true {
                    app.filter.isTapTextSearch = nil
                    focus = false
                }
            }
    }
    
    private var textFilterOff: some View {
        VStack(spacing: 0) {
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
    
    private var textFilterOn: some View {
        VStack(spacing: 0) {
            xmark
            filterByText(namespase: search, id: "box")
                .padding(.vertical)
            Color.clear
                .frame(height: CST.Predict.barBgSize)
                .overlay(alignment: .topLeading) {
                    predictBar
                }
            topButton
                .padding(.bottom)
                .matchedGeometryEffect(id: "press", in: search)
        }
    }
    
    private var predictBar: some View {
        HStack(spacing: 0) {
            Spacer().frame(width: CST.Spacing.standart+CST.Predict.offset)
            HStack(spacing: CST.Spacing.standart/2) {
                ForEach(predictStorage, id: \.self) { str in
                    predictionButton(str)
                }
            }
            Spacer().frame(width: CST.Spacing.standart+CST.Predict.offset)
        }
    }
    
    private var xmark: some View {
        Button {
            withAnimation(.spring(duration: 0.1)) {
                app.filter.isTapTextSearch = false
            }
        } label: {
            Image(systemName: "xmark")
                .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    @State private var predictionLock = false
    
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
                        .onChange(of: tempUserInput) { budgetRegex() }
                }
                .matchedGeometryEffect(id: id, in: tabs)
                .onChange(of: focus) { focusStateChange() }
            Spacer().frame(width: CST.Spacing.standart)
        }
    }
    
    private func predictionButton(_ str: String) -> some View {
        Button {
            tempUserInput = str
        } label: {
            Text(str)
                .font(.system(size: CST.Predict.font))
                .foregroundStyle(.white)
                .background { pButtonBg }
        }
    }
    
    private var pButtonBg: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: CST.Rect.cornerR)
                .foregroundStyle(.blue06)
                .frame(width: geometry.size.width+CST.Predict.offset*2)
                .offset(x: -CST.Predict.offset)
        }
    }
    
    @State var predictStorage: [String] = .init()
    
    private func budgetRegex() {
        if !predictionLock && tempUserInput.count%3 == 0 {
            predictionTimer()
            predictStorage.removeAll()
            if let v = app.getOffers.first(
                where: {$0.name.contains(tempUserInput)} ) {
                predictStorage.append(v.name)
            }
            if let c = app.getOffers.first(
                where: {$0.company.contains(tempUserInput)} ) {
                predictStorage.append(c.company)
            }
        }
    }
    
    private func predictionTimer() {
        predictionLock = true
        let _ = Timer.scheduledTimer(withTimeInterval: 2,
                                     repeats: false) { _ in
            predictionLock = false
        }
    }
    
    private func focusStateChange() {
        if focus && app.filter.isTapTextSearch == false {
            withAnimation(.bouncy) {
                app.filter.isTapTextSearch = true
                app.allowTotalOffersRoll = false
            }
        } else if app.filter.isTapTextSearch == true {
            focus = true
        }
    }
        
    private var scrollTabs: some View {
        SliderOfOptions(isHighlightOn: app.filter.isBigFilterActiveTab,
                        enumValNow: app.filter.bigSliderSelected,
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
        
        struct Predict {
            static let barBgSize = CST.Rect.h*3
            static let offset: CGFloat = 5
            static let font: CGFloat = 24
        }
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
