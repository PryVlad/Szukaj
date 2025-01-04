//
//  StartFilterBig.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 20.12.2024.
//

import SwiftUI

struct StartFilterBig: View {
    //@State private var selected: TabElement.Name = .empty
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
        .onChange(of: app.filter.isOpenFullSearch) {
            if app.filter.isOpenFullSearch {
                //selected = .empty
                app.filter.isBigTap = false
            }
        }
    }
    
    private var botButton: some View {
        DefaultButton(border: Szukaj.color, fill: bgColor,
                      action: { app.filter.isOpenFullSearch = true } )
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
                app.allowRoll = false
            }
        })
        .overlay {
            Text(CST.Button.strTop)
                .font(.title2).fontWeight(.bold)
                .foregroundStyle(.white)
        }
    }
    
    private func searchDecoy(namespase: Namespace.ID, id: String) -> some View {
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
    
//    private var scroll: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(alignment: .center, spacing: 0) {
//                ForEach(CST.elements, id: \.text) { elem in
//                    TabView(tab: elem,
//                            selected: $selected,
//                            namespace: tabs)
//                        .onTapGesture {
//                            selectTab(elem.id)
//                        }
//                }
//            }
//            Self.drawRect(height: 1, opacity: 0.2)
//        }
//        .padding(.leading, CST.spacing)
//    }
        
    private var scroll: some View {
        SliderOfOptions(isHighlightOn: $app.filter.isBigTap,
                        enumValNow: $app.filter.bigSelectedEnumValue,
                        namespace: tabs,
                        tapFunc: updateBigFilter )
        .padding(.leading, CST.spacing)
    }
    
//    private func selectTab(_ id: TabElement.Name) {
//        withAnimation(.spring) {
//            selected = selected == id ? .empty : id
//            updateBigFilter()
//        }
//    }
    
//    private func updateBigFilter() {
//        app.filter.active.removeAll()
//        
//        switch selected {
//        case .fiz:
//            app.numOffers = TabElement.get(.fiz)
//            app.filter.active.insert(
//                SzukajRoot.Fields.stan(.init([.fizyczny]))
//            )
//        case .it:
//            app.numOffers = TabElement.get(.it)
//            app.filter.active.insert(
//                SzukajRoot.Fields.stan(.init([.junior, .MID, .senior]))
//            )
//        default:
//            app.numOffers = TabElement.get(.empty)
//        }
//    }
    
    private func updateBigFilter() {
        app.filter.active.removeAll()
        
        if app.filter.isBigTap {
            switch app.filter.bigSelectedEnumValue {
            case .fiz:
                app.numOffers = FilterModel.bigSelect.get(.fiz)
                app.filter.active.insert(
                    SzukajRoot.Fields.stan(.init([.fizyczny]))
                )
            case .it:
                app.numOffers = FilterModel.bigSelect.get(.it)
                app.filter.active.insert(
                    SzukajRoot.Fields.stan(.init([.junior, .MID, .senior]))
                )
            }
        } else {
            app.numOffers = Szukaj.fakeNumbers[0]
        }
    }
    
//    static func drawRect(height: CGFloat, opacity: CGFloat // private
//    ) -> some View {
//        Rectangle()
//            .frame(height: height)
//            .foregroundStyle(Szukaj.color.opacity(opacity))
//    }
    
    private var bgColor: Color {
        scheme == .light ? .white : .black
    }
    
//    private struct TabView: View {
//        let tab: TabElement
//        @Binding var selected: TabElement.Name
//        let namespace: Namespace.ID
//        
//        var body: some View {
//            HStack(spacing: 0) {
//                Spacer().frame(width: CST.spacing)
//                Label(tab.text, systemImage: tab.sysImg)
//                    .font(.title3).fontWeight(.regular)
//                    .foregroundStyle(tab.id == selected
//                                     ? Szukaj.color
//                                     : .gray)
//                Spacer().frame(width: CST.spacing)
//            }
//            .padding(.top)
//            .overlay(alignment: .bottom) {
//                if selected == tab.id {
//                    StartFilterBig.drawRect(height: CST.activeLineSize,
//                                  opacity: 1)
//                    .offset(y: CST.offsetUnderline)
//                        .matchedGeometryEffect(id: "underline",
//                                               in: namespace.self,
//                                               properties: .frame)
//                } else {
//                    Color.clear.frame(height: CST.activeLineSize)
//                }
//            }
//            .animation(.spring, value: self.selected)
//        }
//    }
    
//    private struct TabElement {
//        let text: String
//        let sysImg: String
//        let id: Name
//        
//        enum Name {
//            case empty, it, fiz
//        }
//        
//        static func get(_ category: Name) -> Int {
//            switch category {
//            case .it:
//                Szukaj.fakeNumbers[1]
//            case .fiz:
//                Szukaj.fakeNumbers[2]
//            default:
//                Szukaj.fakeNumbers[0]
//            }
//        }
//    }
    
    private struct CST {
//        static let offsetUnderline: CGFloat = 14
        static let spacing: CGFloat = 24
//        static let activeLineSize: CGFloat = 2
//        static let elements = [
//            TabElement(text: "IT", sysImg: "desktopcomputer", id: .it),
//            TabElement(text: "Praca fizyczna", sysImg: "wrench", id: .fiz)
//        ]
        
        struct Button {
            static let offset: CGFloat = 30
            static let radius: CGFloat = 40
            static let height: CGFloat = 50
            static let strTop = "🎲  Try to find"
            static let strBot = "More options  "
        }
    }
}

//enum Test: sliderEnum {
//    case one, two
//    
//    static private let lib = [
//        Self.one : ["IT", "desktopcomputer"],
//        Self.two : ["Praca fizyczna", "wrench"]
//    ]
//    
//    var text: String {
//        Self.lib[self]![0]
//    }
//    
//    var sysImg: String {
//        Self.lib[self]![1]
//    }
//    
//    var id: Self {
//        self
//    }
//}
