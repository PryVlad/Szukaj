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
