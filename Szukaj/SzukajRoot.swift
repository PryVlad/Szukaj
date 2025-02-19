//
//  SzukajRoot.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 17.12.2024.
//

import Foundation

struct SzukajRoot {
    var offers: [Offer] = []
    
    init() {
        offers = Self.mockData
    }
    
    static let mockData: [Offer] = [
        Offer(name: "Work", company: "Company Company Company", cv: .szybko,
              img: URL(filePath: "x.com"), loc: "fiz",
              stan: .init( [.fizyczny] ), minSalary: 0, maxSalary: 123),
        Offer(name: "Work", company: "Company Company Company", cv: .niewymagane,
              img: URL(filePath: "x.com"), loc: "menedzer",
              stan: .init( [.menedzer] ), minSalary: 123, maxSalary: 0),
        Offer(name: "Work", company: "Company Company Company", cv: .szybko,
              img: URL(filePath: "x.com"), loc: "senior",
              stan: .init( [.senior] ), minSalary: 123, maxSalary: 123),
        Offer(name: "Work", company: "Company Company Company", cv: .niewymagane,
              img: URL(filePath: "x.com"), loc: "fiz",
              stan: .init( [.fizyczny] ), minSalary: 0, maxSalary: 0),
        Offer(name: "Work", company: "Company Company Company", cv: .szybko,
              img: URL(filePath: "x.com"), loc: "mid",
              stan: .init( [.MID] ), minSalary: 0, maxSalary: 0)
    ]
    
    enum Fields: Hashable {
        case company(String)
        case cv(Offer.CV)
        case loc(String)
        case stan(FEStorage.Stan)
        case minSalary(Int)
        case maxSalary(Int)
    }
    
    struct Offer: Identifiable, Hashable {
        let name: String
        let company: String
        let cv: CV
        let img: URL
        let loc: String
        let stan: FEStorage.Stan
        let minSalary: Int
        let maxSalary: Int
        let id = UUID()

        enum CV: Identifiable, Hashable {
            case niewymagane, dnaTest, szybko
            
            var id: Self {
                self
            }
        }
        
        enum poziomStanowiska: String, FieldElement {
            case praktykant = "praktykant / stazysta"
            case asystent = "asystent"
            case junior = "J - who?"
            case MID = "Mid"
            case senior = "Senior"
            case menedzer = "menedzer"
            case fizyczny = "pracownik fizyczny"
            case robota = "Робота"
        }
    }
}
