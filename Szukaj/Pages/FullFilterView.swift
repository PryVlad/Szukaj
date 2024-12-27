//
//  FullSearchView.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 24.12.2024.
//

import SwiftUI

struct FullFilterView: View {
    @State private var isHiddenStan = false
    
    private var chance: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                stan
                Spacer()
            }
            .padding(.horizontal, CST.rectSpacing)
        }
            .overlay(alignment: .bottom) {
                searchButton
            }
    }
    
    private var searchButton: some View {
        DefaultButton(border: .clear, fill: Szukaj.color, action: {} )
            .overlay {
                HStack(spacing: CST.Button.spacing) {
                    Label(CST.Button.text, systemImage: "magnifyingglass")
                        .foregroundStyle(.white)
                        .font(.title).fontWeight(.semibold)
                    Text("  \(chance, specifier: "%.1f")%  ")
                        .foregroundStyle(Szukaj.color)
                        .font(.title3).fontWeight(.bold)
                        .background {
                            RoundedRectangle(cornerRadius: CST.Button.rRect.radius)
                                .frame(height: CST.Button.rRect.height)
                                .foregroundStyle(.white)
                        }
                }
            }
    }
    
    @ViewBuilder
    private var stan: some View {
        headerStan
            .background(backgroundStan)
            .padding(.bottom, CST.Padding.header)
        if !isHiddenStan {
            ForEach(SzukajRoot.Offer.poziomStanowiska.allCases) { val in
                ClickElement(stan: val)
                    .transition(.asymmetric(insertion: .push(from: .top),
                                            removal: .push(from: .bottom)))
                    .padding(CST.Padding.element)
            }
        }
    }
    
    private var headerStan: some View {
        HStack(spacing: 0) {
            Label("Poziom stanowiska", systemImage: "cellularbars")
                .font(.title2).fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Image(systemName: isHiddenStan ? "chevron.down" : "chevron.up")
                .padding()
        }
    }
    
    private var backgroundStan: some View {
        HStack {
            Spacer().frame(width: CST.rectSpacing)
            RoundedRectangle(cornerRadius: 8).foregroundStyle(Szukaj.colorBG)
            Spacer().frame(width: CST.rectSpacing)
        }
        .onTapGesture {
            withAnimation(.spring) {
                isHiddenStan.toggle()
            }
        }
    }
    
    static let decode: [SzukajRoot.Offer.poziomStanowiska:String] = [
        .asystent : "asystent",
        .fizyczny : "pracownik fizyczny",
        .menedzer : "menedzer",
        .praktykant : "praktykant / stazysta",
        .senior : "Senior",
        .MID : "Mid",
        .junior : "J - who?",
        .robota : "Робота"
    ]
    
    private struct CST {
        static let rectSpacing: CGFloat = 10
        
        struct Padding {
            static let header: CGFloat = 12
            static let element: CGFloat = 6
        }
        
        struct Button {
            static let spacing: CGFloat = 10
            static let text = "Tap?"
            struct rRect {
                static let radius: CGFloat = 30
                static let height: CGFloat = 30
            }
        }
    }
    
    private struct ClickElement: View {
        @State var isSelected = false
        
        let stan: SzukajRoot.Offer.poziomStanowiska
        
        var body: some View {
            HStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .strokeBorder(Szukaj.color, lineWidth: CST.line)
                        .fill(isSelected ? Szukaj.color : .clear)
                        .frame(width: CST.size, height: CST.size,
                               alignment: .leading)
                        .overlay {
                            if isSelected {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.white)
                            }
                        }
                }
                .padding(CST.padding)
                Text(decode[stan]!)
                    .font(.title2)
                Spacer()
            }
            .onTapGesture {
                isSelected.toggle()
            }
        }
        
        private struct CST {
            static let size: CGFloat = 22
            static let line: CGFloat = 2
            static let padding: CGFloat = 12
        }
    }
}

#Preview {
    FullFilterView()
}
