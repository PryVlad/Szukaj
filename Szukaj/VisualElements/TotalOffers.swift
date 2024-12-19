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


struct TotalOffersIntended: View { // TODO: custom transition
    @EnvironmentObject var app: Szukaj
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(getRNumbers(app.numOffers).enumerated().reversed(), id: \.offset) { num in
                Print(digit: num.element)
                    .padding(.trailing, (num.offset)%3 == 0 ? 4 : 0)
            }
            Text("ofert pracy")
        }
        .onChange(of: app.numOffers) {
            app.orderDelay = 0
        }
        .onDisappear {
            app.orderDelay = 0
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
    
    private struct Print: View {
        @EnvironmentObject var app: Szukaj
        @State var ch: Character = "O"
        let digit: Int
        
        var body: some View {
            Text("\(ch)")
                .opacity(opacityVal())
                .onAppear {
                    startAnimation()
                }
                .onChange(of: digit) {
                    startAnimation()
                }
        }
        
        private func opacityVal() -> Double {
            if ch == "O" { return 0 }
            return 1
        }
        
        private func startAnimation() {
            var localDelay: TimeInterval = app.orderDelay
            var by = 1
            var from = 0
            var to = digit+1
            let active = Int(String(ch))
            if let active {
                if digit < active {
                    by = -1
                    from = active
                    to = digit-1
                }
            }
            for i in stride(from: from, to: to, by: by) {
                withAnimation(.linear.delay(localDelay)) {
                    ch = Character(String(i))
                    localDelay+=TimeInterval.random(in: Const.rng)
                }
            }
            app.orderDelay += Const.fromLeftFlipSpeed
        }
    }
    
    private struct Const {
        static let rng = 0.1...0.3
        static let fromLeftFlipSpeed = 0.05
    }
}

