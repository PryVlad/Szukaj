//
//  SzukajRoot.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 17.12.2024.
//

import Foundation

struct SzukajRoot {
    let offers: [Offer] = []
    var fakeOffersCount = Int.random(in: 100...999999999)
    
    static let mockData: [Offer] = [
        Offer(name: "Work", company: "Company Company Company", cv: .szybko, img: "nil", loc: "Location", stan: .init(), minSalary: 0, maxSalary: 123),
        Offer(name: "Work", company: "Company Company Company", cv: .niewymagane, img: "nil", loc: "Location", stan: .init(), minSalary: 123, maxSalary: 0),
        Offer(name: "Work", company: "Company Company Company", cv: .szybko, img: "nil", loc: "Location", stan: .init(), minSalary: 123, maxSalary: 123),
        Offer(name: "Work", company: "Company Company Company", cv: .niewymagane, img: "nil", loc: "Location", stan: .init(), minSalary: 0, maxSalary: 0),
        Offer(name: "Work", company: "Company Company Company", cv: .szybko, img: "nil", loc: "Location", stan: .init(), minSalary: 0, maxSalary: 0)
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
            var id: Self {
                self
            }
            
            case niewymagane, dnaTest, szybko
        }
        
        enum poziomStanowiska {
            case praktykant, asystent, junior, mid, senior, menedzer, fizyczny, robota
        }
    }
}
