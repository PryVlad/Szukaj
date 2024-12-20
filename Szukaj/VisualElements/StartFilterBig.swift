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
    
    var body: some View {
        VStack(spacing: 0) {
            scroll
            HStack(spacing: 0) {
                Spacer().frame(width: 30)
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.gray)
                    .frame(height: 50)
                    .foregroundStyle(.white)
                Spacer().frame(width: 30)
            }
            .padding(.vertical)
        }
        .background(CST.background)
    }
    
    private var scroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 0) {
                ForEach(CST.elements, id: \.text) { elem in
                        elementView(elem)
                        .overlay(alignment: .bottom) {
                            if selected == elem.id {
                                Self.drawRect(height: CST.activeLineSize,
                                              opacity: 1)
                                    .offset(y: CST.offset)
                            }
                        }
                    .onTapGesture {
                        withAnimation(.spring) {
                            selected = Self.update(selected, to: elem.id)
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
    
    static private func update(
        _ selected: TabElement.Name, to val: TabElement.Name
    ) -> TabElement.Name {
        if selected == val {
            return .empty
        }
        return val
    }
    
    static private func drawRect(height: CGFloat, opacity: CGFloat) -> some View {
        Rectangle()
            .frame(height: height)
            .foregroundStyle(Szukaj.color.opacity(opacity))
    }
    
    private func elementView(_ elem: TabElement) -> some View {
        HStack(spacing: 0) {
            Spacer().frame(width: CST.spacing)
            Label(elem.text, systemImage: elem.sysImg)
                .font(.title3).fontWeight(.regular)
                .foregroundStyle(elem.id == selected ? Szukaj.color : .gray)
            Spacer().frame(width: CST.spacing)
        }
        .padding(.top)
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
        static let background: Color = .white
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
