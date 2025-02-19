//
//  OfferView.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 19.12.2024.
//

import SwiftUI

struct OfferView: View {
    @State private var isNoted = false
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var app: Szukaj
    
    let offer: SzukajRoot.Offer
    
    var body: some View {
        VStack(spacing: 0) {
            top.padding(.bottom, CST.Padding.Above.img)
            mid.padding(.bottom, CST.Padding.Above.line)
            bot
        }
        .background(Rectangle().foregroundStyle(bgColor))
        .onAppear {
            visibleStar()
        }
    }
    
    @ViewBuilder
    private var bot: some View {
        VStack(alignment: .leading, spacing: 0) {
            if offer.cv != .niewymagane {
                Rectangle().frame(height: 1)
                    .foregroundStyle(Szukaj.color.opacity(0.2))
            }
            Group {
                if offer.cv == .szybko {
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
            //let img = AsyncImage(url: URL)
            Rectangle().frame(width: CST.Size.img, height: CST.Size.img)
            VStack(alignment: .leading, spacing: 0) {
                Text(offer.company)
                    .font(.title2).fontWeight(.semibold)
                Text(offer.loc)
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
                if offer.minSalary == 0 && offer.maxSalary == 0 {
                    Text(offer.name)
                        .font(.title2).fontWeight(.bold)
                } else {
                    whenSalaryExist
                }
            }
            .padding()
            .frame(height: CST.Size.topTextArea)
            Spacer()
            star
        }
    }
    
    @ViewBuilder
    private var whenSalaryExist: some View {
        Spacer().frame(height: CST.Padding.Above.title)
        Text(offer.name)
            .font(.title2).fontWeight(.bold)
            .padding(.bottom, CST.Padding.betweenTitle)
        salary
            .font(.title3).fontWeight(.bold)
            .foregroundStyle(.gray)
    }
    
    private var salary: Text {
        if offer.minSalary > 0 && offer.maxSalary == 0 {
            return Text("\(offer.minSalary) - ... zl")
        }
        if offer.minSalary == 0 && offer.maxSalary > 0 {
            return Text("\(offer.maxSalary) zl")
        }
        return Text("\(offer.minSalary) - \(offer.maxSalary) zl")
    }
    
    private func visibleStar() {
        // array of bools for all visible and access by index = alternative
        if app.visibleStars < app.noted.count {
            if app.noted.contains(where: {$0.id == offer.id} ) {
                isNoted = true
                app.visibleStars+=1
            }
        }
    }
    
    private var star: some View { // NavStack can backfire
        Image(systemName: isNoted ? "star.fill" : "star")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: CST.Size.star, height: CST.Size.star)
            .foregroundStyle(.yellow)
            .background(
                Rectangle().frame(width: CST.Size.star*CST.multStarArea,
                                  height: CST.Size.star*CST.multStarArea)
                    .onTapGesture {
                        starTap()
                    }
                    .foregroundStyle(bgColor)
            )
            .padding(.horizontal, CST.Padding.starHorizontal)
    }
    
    private func starTap() {
        isNoted.toggle()
        if !app.noted.contains(where: {$0 == offer} ) {
            app.noted.append(offer)
            app.visibleStars += 1
        } else {
            withAnimation(.spring) {
                app.noted.removeAll(where: {$0 == offer} )
            }
            app.visibleStars -= 1
        }
    }
    
    private var bgColor: Color {
        scheme == .light ? .white : .black
    }
    
    private struct CST {
        static let multStarArea = 1.6
        
        struct Size {
            static let img: CGFloat = 100
            static let star: CGFloat = 30
            static let topTextArea: CGFloat = 90
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

//#Preview {
//    OfferView(offer: SzukajRoot.mockData[1])
//}
