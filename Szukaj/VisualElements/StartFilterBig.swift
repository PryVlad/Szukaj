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
        }
        .background(bgColor)
    }
    
    private var searchDecoy: some View {
        HStack(spacing: 0) {
            Spacer().frame(width: 30)
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.gray)
                .frame(height: 50)
                .foregroundStyle(.white)
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
            app.numOffers = SzukajRoot.getFiz()
            app.activeFilters.append(SzukajRoot.Fields.stan(.init([.fizyczny])))
        case .it:
            app.numOffers = SzukajRoot.getIT()
            app.activeFilters.append(SzukajRoot.Fields.stan(.init([.junior, .MID, .senior])))
        default:
            app.numOffers = SzukajRoot.getAll()
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
                        .offset(y: CST.offset)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace.self,
                                               properties: .frame)
                } else {
                    Color.clear.frame(height: 2)
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
    }
    
    private struct CST {
        static let offset: CGFloat = 14
        static let spacing: CGFloat = 24
        static let activeLineSize: CGFloat = 2
        static let elements = [
            TabElement(text: "IT", sysImg: "desktopcomputer", id: .it),
            TabElement(text: "Praca fizyczna", sysImg: "wrench", id: .fiz)
        ]
    }
}

#Preview {
    StartFilterBig()
}
