//
//  StartFilterBig.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 20.12.2024.
//

import SwiftUI

struct StartFilterBig: View {
    @State private var selected: TabElement.Name = .empty
    @EnvironmentObject private var app: Szukaj
    @Environment(\.colorScheme) var scheme
    @Namespace var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            scroll
            searchDecoy
                .padding(.vertical)
            buttons
                .padding(.bottom)
        }
        .background(bgColor)
    }
    
    private var buttons: some View {
        Group {
            createButton(border: .clear, fill: Szukaj.color,
                         action: {print("top")} )
            .overlay {
                Text(CST.Button.strTop)
                    .font(.title2).fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            .padding(.top)
            createButton(border: Szukaj.color, fill: .clear,
                         action: {print("bot")} )
            .overlay {
                Text(CST.Button.strBot)
                    .font(.title2).fontWeight(.semibold)
                    .foregroundStyle(Szukaj.color)
            }
            .padding(.bottom)
        }
    }
    
    private func createButton(border: Color, fill: Color, action: @escaping ()->Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 0) {
                Spacer().frame(width: CST.Button.offset)
                RoundedRectangle(cornerRadius: CST.Button.radius)
                    .strokeBorder(border)
                    .fill(fill)
                    .frame(height: CST.Button.height)
                Spacer().frame(width: CST.Button.offset)
            }
        }
        .buttonStyle(.plain)
    }
    
    private func buttonStyle(border: Color, fill: Color) -> some View {
        HStack(spacing: 0) {
            Spacer().frame(width: CST.Button.offset)
            RoundedRectangle(cornerRadius: CST.Button.radius)
                .strokeBorder(border)
                .fill(fill)
                .frame(height: CST.Button.height)
            Spacer().frame(width: CST.Button.offset)
        }
    }
    
    private var searchDecoy: some View {
        HStack(spacing: 0) {
            Spacer().frame(width: 30)
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.gray)
                .frame(height: 50)
                .foregroundStyle(.white)
                .overlay(alignment: .leading) {
                    Text("WIP")
                }
            Spacer().frame(width: 30)
        }
    }
    
    private var scroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 0) {
                ForEach(CST.elements, id: \.text) { elem in
                    TabView(tab: elem, selected: $selected, namespace: namespace)
                        .onTapGesture {
                            withAnimation(.spring) {
                                selected = selected == elem.id ? .empty : elem.id
                                updateBigFilter()
                            }
                        }
                }
            }
            Self.drawRect(height: 1, opacity: 0.2)
        }
        .padding(.leading, CST.spacing)
    }
    
    private func updateBigFilter() {
        app.activeFilters.removeAll()
        
        switch selected {
        case .fiz:
            app.numOffers = TabElement.get(.fiz)
            app.activeFilters.append(SzukajRoot.Fields.stan(.init([.fizyczny])))
        case .it:
            app.numOffers = TabElement.get(.it)
            app.activeFilters.append(SzukajRoot.Fields.stan(.init([.junior, .MID, .senior])))
        default:
            app.numOffers = TabElement.get(.empty)
        }
    }
    
    static private func drawRect(height: CGFloat, opacity: CGFloat) -> some View {
        Rectangle()
            .frame(height: height)
            .foregroundStyle(Szukaj.color.opacity(opacity))
    }
    
    private var bgColor: Color {
        scheme == .light ? .white : .black
    }
    
    private struct TabView: View {
        let tab: TabElement
        @Binding var selected: TabElement.Name
        let namespace: Namespace.ID
        
        var body: some View {
            HStack(spacing: 0) {
                Spacer().frame(width: CST.spacing)
                Label(tab.text, systemImage: tab.sysImg)
                    .font(.title3).fontWeight(.regular)
                    .foregroundStyle(tab.id == selected ? Szukaj.color : .gray)
                Spacer().frame(width: CST.spacing)
            }
            .padding(.top)
            .overlay(alignment: .bottom) {
                if selected == tab.id {
                    StartFilterBig.drawRect(height: CST.activeLineSize,
                                  opacity: 1)
                    .offset(y: CST.offsetUnderline)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace.self,
                                               properties: .frame)
                } else {
                    Color.clear.frame(height: CST.activeLineSize)
                }
            }
            .animation(.spring, value: self.selected)
        }
    }
    
    private struct TabElement {
        let text: String
        let sysImg: String
        let id: Name
        
        enum Name {
            case empty, it, fiz
        }
        
        static func get(_ category: Name) -> Int {
            switch category {
            case .it:
                Szukaj.fakeNumbers[1]
            case .fiz:
                Szukaj.fakeNumbers[2]
            default:
                Szukaj.fakeNumbers[0]
            }
        }
    }
    
    private struct CST {
        static let offsetUnderline: CGFloat = 14
        static let spacing: CGFloat = 24
        static let activeLineSize: CGFloat = 2
        static let elements = [
            TabElement(text: "IT", sysImg: "desktopcomputer", id: .it),
            TabElement(text: "Praca fizyczna", sysImg: "wrench", id: .fiz)
        ]
        
        struct Button {
            static let offset: CGFloat = 30
            static let radius: CGFloat = 40
            static let height: CGFloat = 50
            static let strTop = "🎲  Try to find"
            static let strBot = "More options  ➡️"
        }
    }
}

#Preview {
    StartFilterBig()
}
