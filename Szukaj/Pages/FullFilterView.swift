//
//  FullSearchView.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 24.12.2024.
//

import SwiftUI

struct FullFilterView: View {
    typealias STAN = SzukajRoot.Offer.poziomStanowiska
    @EnvironmentObject private var app: Szukaj
    
    @Binding var isButtonPressed: Bool
    private var chance: Double
    
    init(filterState: Binding<Bool>) {
        _isButtonPressed = filterState
        chance = 0
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: CST.Button.spacing)
            ScrollView {
                FFSelectSection(accumulator: FEStorage.Stan(),
                              isTapButton: $isButtonPressed,
                              label: "Poziom stanowiska",
                              sysImg: "cellularbars")
                Spacer()
            }
            .padding(.horizontal, CST.paddingSelectionH)
            searchButton
            Spacer().frame(height: CST.Button.spacing)
        }
        .onDisappear {
            isButtonPressed = false
        }
    }
    
    private var searchButton: some View {
        DefaultButton(border: .clear, fill: Szukaj.color, action: {
            isButtonPressed = true
            app.filter.isOpenFullSearch = false
        })
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
    
    private struct CST {
        static let paddingSelectionH: CGFloat = 10
        
        struct Button {
            static let spacing: CGFloat = 10
            static let text = "Tap?"
            struct rRect {
                static let radius: CGFloat = 30
                static let height: CGFloat = 30
            }
        }
    }
}









struct Preview: View {
    @State var temp = false
    
    var body: some View {
        FullFilterView(filterState: $temp)
    }
}

#Preview {
    Preview()
}
