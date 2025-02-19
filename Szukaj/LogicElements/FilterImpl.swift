//
//  FilterImpl.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 19.12.2024.
//

import Foundation

protocol FilterStrategy {
    func filter(
        offers: [SzukajRoot.Offer], by field: Set<SzukajRoot.Fields>
    ) -> [SzukajRoot.Offer]
}

final class Filter {
    typealias offer = SzukajRoot.Offer
    
    private var strategy: FilterStrategy
    
    init(strategy: FilterStrategy) {
        self.strategy = strategy
    }
    
    func update(strategy: FilterStrategy) {
        self.strategy = strategy
    }
    
    func applyFilter(
        to offers: [offer], withField field: Set<SzukajRoot.Fields>
    ) -> [offer] {
        strategy.filter(offers: offers, by: field)
    }
    
    final class CV: FilterStrategy {
        func filter(offers: [offer], by field: Set<SzukajRoot.Fields>) -> [offer] {
            let CVfilter = Set(field.compactMap { val -> SzukajRoot.Offer.CV? in
                if case let .cv(cV) = val { return cV }; return nil
            })
            return offers.filter { !CVfilter.contains($0.cv) }
        }
    }
    
    final class STAN: FilterStrategy {
        func filter(offers: [offer], by field: Set<SzukajRoot.Fields>) -> [offer] {
            for val in field {
                if case let .stan(unpack) = val {
                    if unpack.wrapper.storage.values.isEmpty {
                        return offers
                    }
                    return offers.filter { $0.stan.wrapper.storage.values.isSubset(
                        of: unpack.wrapper.storage.values) }
                }
            }
            return offers
        }
    }
}
    
    // MARK: part 2
    
protocol OfferFilter {
    func filter(
        offers: [SzukajRoot.Offer], by field: Set<SzukajRoot.Fields>
    ) -> [SzukajRoot.Offer]
}

class OfferBaseFilter: OfferFilter {
    func filter(
        offers: [SzukajRoot.Offer], by field: Set<SzukajRoot.Fields>
    ) -> [SzukajRoot.Offer] {
        return offers
    }
}

class OfferFilterDecorator: OfferFilter {
    private let offerFilter: OfferFilter
    
    typealias offer = SzukajRoot.Offer
    
    init(offerFilter: OfferFilter) {
        self.offerFilter = offerFilter
    }
    
    func filter(
        offers: [offer], by field: Set<SzukajRoot.Fields>
    ) -> [offer] {
        return offerFilter.filter(offers: offers, by: field)
    }
}

final class OfferCVFilter: OfferFilterDecorator {
    override func filter(offers: [offer], by field: Set<SzukajRoot.Fields>) -> [offer] {
        let filter = Filter(strategy: Filter.CV())
        let appliedFilterResult = super.filter(offers: offers, by: field)
        let filteredOffers = filter.applyFilter(to: appliedFilterResult, withField: field)
        return filteredOffers
    }
}

final class OfferSTANFilter: OfferFilterDecorator {
    override func filter(offers: [offer], by field: Set<SzukajRoot.Fields>) -> [offer] {
        let filter = Filter(strategy: Filter.STAN())
        let appliedFilterResult = super.filter(offers: offers, by: field)
        let filteredOffers = filter.applyFilter(to: appliedFilterResult, withField: field)
        return filteredOffers
    }
}

    // MARK: Part 3 ...

protocol FieldElement: RawRepresentable<String>,Hashable,Equatable,
                       CaseIterable where AllCases == Array<Self> {
    func isFound(in source: Szukaj) -> Bool
}

protocol ConfirmFEValues: Hashable&Equatable {
    associatedtype FE: FieldElement
    var values: Set<FE> { get set }
}

protocol ConfirmFEWrapper: Hashable&Equatable {
    associatedtype VAL: ConfirmFEValues
    var storage: VAL { get }
    var allCases: VAL.FE.AllCases { get }
    mutating func add(_ elem: VAL.FE)
    mutating func remove(_ elem: VAL.FE)
}

protocol ConfirmFEStorage: Hashable&Equatable {
    associatedtype WRAP: ConfirmFEWrapper
    var wrapper: WRAP { get set }
    func update(_ source: Szukaj)
}

struct FEStorage {
    struct Stan: ConfirmFEStorage {
        typealias STAN = SzukajRoot.Offer.poziomStanowiska
        
        var wrapper = ConfirmFE.Wrap(ConfirmFE.Val<STAN>([]))
        
        init() {}
        
        init(_ values: Set<STAN>) {
            wrapper.storage.values = values
        }
        
        func update(_ source: Szukaj) {
            source.filter.active = [.stan(.init(wrapper.storage.values))]
        }
    }
}

struct ConfirmFE {
    struct Wrap<T: ConfirmFEValues>: ConfirmFEWrapper {
        var storage: T

        init(_ storage: T) {
            self.storage = storage
        }
        
        var allCases: Array<T.FE> {
            T.FE.allCases
        }
        
        mutating func add(_ elem: T.FE) {
            storage.values.insert(elem)
        }
        
        mutating func remove(_ elem: T.FE) {
            storage.values.remove(elem)
        }
        
        static func == (lhs: ConfirmFE.Wrap<T>, rhs: ConfirmFE.Wrap<T>) -> Bool {
            lhs.storage == rhs.storage
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(storage.values)
        }
    }
    
    class Val<E: FieldElement>: ConfirmFEValues {
        var values: Set<E>
        
        init(_ values: Set<E>) {
            self.values = values
        }
        
        static func == (lhs: ConfirmFE.Val<E>, rhs: ConfirmFE.Val<E>) -> Bool {
            lhs.values == rhs.values
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(values)
        }
    }
}
