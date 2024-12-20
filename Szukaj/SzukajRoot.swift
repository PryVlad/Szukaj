//
//  SzukajRoot.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 17.12.2024.
//

import Foundation

struct SzukajRoot {
    let offers: [Offer] = []
    var fakeOffersCount = Self.fakeNumbers[0]
    
    static let fakeNumbers: [Int] = [
        Int.random(in: 21000...999999999),
        Int.random(in: 5000...7000),
        Int.random(in: 7000...14000)
    ]
    
    static func getIT() -> Int {
        fakeNumbers[1]
    }
    static func getFiz() -> Int {
        fakeNumbers[2]
    }
    static func getAll() -> Int {
        fakeNumbers[0]
    }
    
    
    static let mockData: [Offer] = [
        Offer(name: "Work", company: "Company Company Company", cv: .szybko, img: "nil", loc: "Location",
              stan: .init([.fizyczny]), minSalary: 0, maxSalary: 123),
        Offer(name: "Work", company: "Company Company Company", cv: .niewymagane, img: "nil", loc: "Location",
              stan: .init(), minSalary: 123, maxSalary: 0),
        Offer(name: "Work", company: "Company Company Company", cv: .szybko, img: "nil", loc: "Location",
              stan: .init(), minSalary: 123, maxSalary: 123),
        Offer(name: "Work", company: "Company Company Company", cv: .niewymagane, img: "nil", loc: "Location",
              stan: .init(), minSalary: 0, maxSalary: 0),
        Offer(name: "Work", company: "Company Company Company", cv: .szybko, img: "nil", loc: "Location",
              stan: .init([.MID]), minSalary: 0, maxSalary: 0)
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
    
    enum Fields {
        case company(String)
        case cv(Offer.CV)
        case loc(String)
        case stan(Set<Offer.poziomStanowiska>)
        case minSalary(Int)
        case maxSalary(Int)
    }
    
    struct Offer: Identifiable, Hashable {
        let name: String
        let company: String
        let cv: CV
        let img: String
        let loc: String // definitely not efficient
        let stan: Set<poziomStanowiska>
        let minSalary: Int
        let maxSalary: Int
        let id = UUID()
        
        enum CV: Identifiable, Hashable {
            case niewymagane, dnaTest, szybko
            
            var id: Self {
                self
            }
        }
        
        enum poziomStanowiska {
            case praktykant, asystent, junior, MID, senior, menedzer, fizyczny, robota
        }
    }
}
