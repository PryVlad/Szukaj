//
//  SzukajRoot.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 17.12.2024.
//

import Foundation

struct SzukajRoot {
    let offers: [Offer] = []
    let fakeOffersCount = Int.random(in: 100...999999999)
    
    struct Offer {
        let name: String
        let cv: offerCV
        let img: String
        let loc: String // definitely not efficient
        let cat: offerCategory
        let stan: Set<poziomStanowiska>
        
        init(name: String, cv: offerCV, img: String, loc: String,
             stan: Set<poziomStanowiska>) {
            self.name = name
            self.cv = cv
            self.img = img
            self.loc = loc
            self.cat = Self.setCategory(stan)
            self.stan = stan
        }
        
        static private func setCategory(_ stan: Set<poziomStanowiska>) -> offerCategory {
            if stan.contains(where: {$0 == poziomStanowiska.fizyczny} ) {
                return offerCategory.fiz
            }
            if stan.contains(where: {$0 == poziomStanowiska.junior ||
                $0 == poziomStanowiska.mid || $0 == poziomStanowiska.senior} ) {
                return offerCategory.it
            }
            return offerCategory.all
        }
        
        enum offerCV {
            case niewymagane, dnaTest
        }
        
        enum offerCategory {
            case all, it, fiz
        }
        
        enum poziomStanowiska {
            case praktykant, asystent, junior, mid, senior, menedzer, fizyczny
        }
    }
}
