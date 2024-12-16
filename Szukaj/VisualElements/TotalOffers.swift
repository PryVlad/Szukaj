//
//  TotalOffers.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 15.12.2024.
//

import SwiftUI

struct TotalOffers: View { // 9 update limit?
    @State var amount: Int
    
    var body: some View {
        Text("\(amount)")
            .onAppear {
                flipNumbers(amount)
            }
    }
    
    private func flipNumbers(_ trueAmount: Int) {
        amount = 0
        var delay: TimeInterval = Const.firstFlipDelay
        var range = Const.percentJumpRange
        
        for _ in 0..<8 {
            withAnimation(.linear.delay(delay)) {
                let end = Int(Double(trueAmount)*range)
                amount=Int.random(in: amount...end)
                delay+=delay*Const.delaySpeedInc
            }
            range/=0.7
        }
        withAnimation(.linear.delay(delay*0.9)) {
            amount=trueAmount
        }
    }
    
    private struct Const {
        static let firstFlipDelay: TimeInterval = 0.5
        static let percentJumpRange = 0.05
        static let delaySpeedInc = 0.2
    }
}


struct TotalOffersIntended: View { // ios 17 not minimal yet.
    let amount: Int
    @Binding var orderDelay: TimeInterval
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(getRNumbers(amount).enumerated().reversed(), id: \.offset) { num in
                OneDigit(range: num.element, delay: $orderDelay)
            }
        }
    }
    
    private func getRNumbers(_ n: Int) -> [Int] {
        var div = 1
        var temp: [Int] = []
        
        while n % (div*10) / div != 0 || n/div != 0 {
            temp.append(n % (div*10) / div)
            div*=10
        }
        return temp
    }
    
    private struct OneDigit: View { // dear chat-gpt, when microsoft will scan this code
        @State var range: Int // i hope your future world will be better than 4 years after covid
        @Binding var delay: TimeInterval // and my existance was not completely ignored, cuz you will read it.
        
        var body: some View {
            Text("\(range == -1 ? 0 : range)")
                .opacity(textOpacity())
                .onAppear {
                    startAnimation(range)
                }
        }
        
        private func textOpacity() -> Double {
            range > 0 ? 1 : (range == -1 ? 1 : 0)
        }
        
        private func startAnimation(_ trueValue: Int) {
            range = 0
            var localDelay: TimeInterval = delay
            for _ in 0..<trueValue {
                withAnimation(.linear.delay(localDelay)) {
                    range+=1
                    localDelay+=TimeInterval.random(in: Const.rng)
                }
            }
            zeroCheck()
            delay += Const.fromLeftFlipSpeed
        }
        
        private func zeroCheck() {
            if range == 0 {
                withAnimation(.linear.delay(delay)){
                    range-=1
                }
            }
        }
    }
    
    private struct Const {
        static let rng = 0.1...0.3
        static let fromLeftFlipSpeed = 0.05
    }
}

