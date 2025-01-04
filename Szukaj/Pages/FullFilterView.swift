//
//  FullSearchView.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 24.12.2024.
//

import SwiftUI

struct FullFilterView: View {
    typealias stan = SzukajRoot.Offer.poziomStanowiska
//    @State private var isButtonPressed = false
    @EnvironmentObject private var app: Szukaj
    @Binding var isButtonPressed: Bool
    
    private var chance: Double = 0
    
    init(filterState: Binding<Bool>) {
        _isButtonPressed = filterState
        chance = 0
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                SelectSection<stan>(button: $isButtonPressed,
                                    label: "Poziom stanowiska",
                                    sysImg: "cellularbars")
                Spacer()
            }
            .padding(.horizontal, CST.Padding.selectionH)
            searchButton
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
        static let labelRectSpacingH: CGFloat = 6
        
        struct Padding {
            static let header: CGFloat = 12
            static let element: CGFloat = 10
            static let selectionH: CGFloat = 10
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
    
    private struct SelectSection<T: ConfirmField>: View {
        @EnvironmentObject private var app: Szukaj
        @State private var isHidden = false
        
        @State var field: FieldStorage = WrapperField<T>()
        @Binding var button: Bool
        
        let label: String
        let sysImg: String
        
        var body: some View {
            topLabel(label, sysImg: sysImg)
                .background(background)
                .padding(.bottom, isHidden ? 0 : CST.Padding.header)
                .onChange(of: button) {
                    if button {
                        compareTypesAddFilter()
                    }
                }
            VStack(spacing: 0) {
                if !isHidden {
                    VStack(spacing: 0) {
                        ForEach(field.allCases, id: \.rawValue) { val in
                            FFRowView(accum: $field, elem: val)
                                .padding([.horizontal, .bottom], CST.Padding.element)
                        }
                    }
                } else {
                    Color.clear.frame(height: 1)
                }
            }
            .transition(.standartPush())
            .clipped()
        }
        
        private func compareTypesAddFilter() {
            var exist = false
            
            if type(of: T.self) == type(of: SzukajRoot.Offer.poziomStanowiska.self) {
                let temp = field as! WrapperField<SzukajRoot.Offer.poziomStanowiska>
                
//                for loop in app.activeFilters {
                for loop in app.filter.active {
                    if case let .stan(wrapperField) = loop {
                        wrapperField.value.formSymmetricDifference(temp.value)
                        exist.toggle()
                        if wrapperField.value.isEmpty {
                            app.filter.active.remove(.stan(wrapperField))
                        }
                    }
                }
                if !exist {
                    app.filter.active.insert(SzukajRoot.Fields.stan(temp))
                }
            }
        }
        
        private func topLabel(_ text: String, sysImg: String) -> some View {
            HStack(spacing: 0) {
                Label(text, systemImage: sysImg)
                    .font(.title2).fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                Image(systemName: isHidden ? "chevron.down" : "chevron.up")
                    .padding()
            }
        }
        
        private var background: some View {
            HStack {
                Spacer().frame(width: CST.labelRectSpacingH)
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Szukaj.colorBG)
                Spacer().frame(width: CST.labelRectSpacingH)
            }
            .onTapGesture {
                withAnimation(.spring) {
                    isHidden.toggle()
                }
            }
        }
    }//SelectSection
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
