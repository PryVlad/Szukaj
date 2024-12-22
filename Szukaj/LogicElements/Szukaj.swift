//
//  ViewModel.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 16.12.2024.
//

import SwiftUI

class Szukaj: ObservableObject {
    @Published private var szukaj = SzukajRoot()
    @Published var activeNav: NavName = .start
    @Published var activeFilters: [SzukajRoot.Fields] = []
    
    var orderDelay: TimeInterval = 0
    var numOffers: Int = fakeNumbers[0]

    var getOffers: [SzukajRoot.Offer] {
        let cv = OfferCVFilter(offerFilter: OfferBaseFilter())
        let stan = OfferSTANFilter(offerFilter: cv)
        return stan.filter(offers: szukaj.offers, by: activeFilters)
    }
    
    func reachBottom() { // LoadingView, await
        let limit = 100
        let addCount = 10
        if szukaj.offers.count < limit {
            for _ in 0..<addCount {
                szukaj.offers.append(createRandomOffer())
            }
        }
    }
    
    private func createRandomOffer() -> SzukajRoot.Offer {
        let cv: [SzukajRoot.Offer.CV] = [.niewymagane, .szybko]
        let stan: [SzukajRoot.Offer.poziomStanowiska] = [
            .MID, .menedzer, .robota, .fizyczny
        ]
        return SzukajRoot.Offer(name: "Work", company: "Company", cv: cv.randomElement()!,
                                img: URL(filePath: "img"), loc: "Location",
                                stan: [stan.randomElement()!],
                                minSalary: Int.random(in: 0...20),
                                maxSalary: Int.random(in: 21...999))
    }
    
    static let color: Color = .blue.mix(with: .indigo, by: 0.5)
    
    static let fakeNumbers: [Int] = [
        Int.random(in: 21000...999999999),
        Int.random(in: 5000...7000),
        Int.random(in: 7000...14000)
    ]
    
    static let ConfuciusQuote = [
        "Better a diamond with a flaw than a CV without.",
        "I hear, I know. I see, I remember. I do, I szukaj.",
        "Szukaj the CV, if you would difine the future.",
        "You cannot open a szukaj without learning something.",
        "Everyone has CV, but not everyone sees it.",
        "Szukaj yourself, and others will szukaj you.",
        "Szukaj a job you love, and you will never have to work a day in your life."
    ]
    
    enum NavName: CaseIterable, Identifiable {
        case start, noted, konto, menu
        
        var id: Self {
            self
        }
        
        static private let lib = [
            NavName.start : ["Start", "house"],
            NavName.noted : ["Noted", "star.square"],
            NavName.konto : ["Konto", "person.circle"],
            NavName.menu : ["Menu", "list.bullet"]
        ]
        
        static func getStr(_ nav: NavName) -> String {
            lib[nav]![0]
        }
        
        static func getIcon(_ nav: NavName) -> String {
            lib[nav]![1]
        }
    }
}
