//
//  OfferView.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 19.12.2024.
//

import SwiftUI

struct OfferView: View {
    @State var isNoted = false
    
    let temp: SzukajRoot.Offer.CV
    
    var body: some View {
        VStack(spacing: 0) {
            top
                .padding(.bottom, CST.Padding.Above.img)
            mid
                .padding(.bottom, CST.Padding.Above.line)
            bot
        }
        .background(CST.background)
    }
    
    @ViewBuilder
    private var bot: some View {
        VStack(alignment: .leading, spacing: 0) {
            if temp != .niewymagane {
                Rectangle().frame(height: 1)
                    .foregroundStyle(Szukaj.color.opacity(0.2))
            }
            Group {
                if temp == .szybko {
                    Label("szybko", systemImage: "bolt")
                        .foregroundStyle(.gray)
                        .font(.title2).fontWeight(.light)
                        .padding(.vertical, CST.Padding.BotText.v)
                }
            }
            .padding(.horizontal, CST.Padding.BotText.h)
        }
    }
    
    private var mid: some View {
        HStack(alignment: .top, spacing: 0) {
            Rectangle().frame(width: CST.Size.img, height: CST.Size.img)
            VStack(alignment: .leading, spacing: 0) {
                Text("Company Company Company Company")
                    .font(.title2).fontWeight(.semibold)
                Text("Location")
                    .font(.title3).fontWeight(.light)
                    .padding(.top)
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var top: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: CST.Padding.Above.title)
                Text("Work")
                    .font(.title2).fontWeight(.bold)
                    .padding(.bottom, CST.Padding.betweenTitle)
                Text("ItsEasySure")
                    .font(.title3).fontWeight(.bold)
                    .foregroundStyle(.gray)
            }
            .padding()
            Spacer()
            star
        }
    }
    
    private var star: some View { // NavStack tap maybe broke in future
        Image(systemName: isNoted ? "star.fill" : "star")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CST.Size.star, height: CST.Size.star)
            .foregroundStyle(.yellow)
            .background(
                Rectangle().frame(width: CST.Size.star*CST.multStarArea,
                                  height: CST.Size.star*CST.multStarArea)
                    .onTapGesture {
                        isNoted.toggle()
                    }
                    .foregroundStyle(CST.background)
            )
            .padding(.horizontal, CST.Padding.starHorizontal)
    }
    
    private struct CST {
        static let multStarArea = 1.6
        static let background: Color = .white
        
        struct Size {
            static let img: CGFloat = 100
            static let star: CGFloat = 30
        }
        struct Padding {
            static let betweenTitle: CGFloat = 4
            static let starHorizontal: CGFloat = 30
            
            struct Above {
                static let img: CGFloat = 10
                static let line: CGFloat = 20
                static let title: CGFloat = 10
            }
            struct BotText {
                static let h: CGFloat = 20
                static let v: CGFloat = 10
            }
        }
    }
}

#Preview {
    OfferView(temp: .szybko)
}
