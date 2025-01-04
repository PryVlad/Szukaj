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
                if case let .stan(set) = val {
                    return offers.filter { $0.stan.value.isSubset(of: set) }
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

protocol FieldElement { var rawValue: String { get } }
protocol ConfirmField: FieldElement, Hashable, CaseIterable {
    static var all: [FieldElement] { get }
}

protocol FieldStorage {
    var allCases: [FieldElement] { get }
    func add(_ val: FieldElement)
    func remove(_ val: FieldElement)
    func contains(_ val: FieldElement) -> Bool
    var getValues: [FieldElement] { get }
}
protocol ConfirmFieldStorage: FieldStorage,Equatable,Hashable,Sequence {}

final class WrapperField<T: ConfirmField>: ConfirmFieldStorage {
    var value: Set<T>
    var allCases: [FieldElement] {
        T.all
    }
    
    var getValues: [FieldElement] {
        Array(value)
    }
    
    init() { value = .init() }
    
    init(_ value: [T]) {
        self.value = .init(value)
    }
    
    func add(_ val: FieldElement) {
        value.insert(val as! T)
    }
    
    func remove(_ val: FieldElement) {
        value.remove(val as! T)
    }
    
    func contains(_ val: FieldElement) -> Bool {
        value.contains(where: {$0 == val as! T})
    }
    
    func makeIterator() -> Set<T>.Iterator {
        value.makeIterator()
    }
    
    static func == (lhs: WrapperField, rhs: WrapperField) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
}

//final class Wrapper {
//    final class Stan: SelectableRequired {
//        typealias VType = SzukajRoot.Offer.poziomStanowiska
//        
//        var value: Set<VType> // can be private
//        var allCases: [FieldElement] {
//            VType.allCases
//        }
//        
//        init() { value = .init() }
//        
//        init(_ value: [VType]) {
//            self.value = .init(value)
//        }
//        
//        func add(_ val: FieldElement) {
//            value.insert(val as! Wrapper.Stan.VType)
//        }
//        
//        func remove(_ val: FieldElement) {
//            value.remove(val as! Wrapper.Stan.VType)
//        }
//        
//        func contains(_ val: FieldElement) -> Bool {
//            value.contains(where: {$0 == val as! Wrapper.Stan.VType})
//        }
//        
//        func makeIterator() -> Set<VType>.Iterator {
//            value.makeIterator()
//        }
//        
//        static func == (lhs: Wrapper.Stan, rhs: Wrapper.Stan) -> Bool {
//            lhs === rhs
//        }
//        
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(value)
//        }
//    }
//}


//final class Field: Selectable, Hashable, Equatable {
//    var value: [Selectable]
//    
//    init(value: [Selectable] ) {
//        self.value = value
//    }
//    
//    static func == (lhs: Field, rhs: Field) -> Bool {
//        lhs == rhs
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(10)
//    }
//}


//protocol Selectable {
//    associatedtype T
//}
//
//struct WrapperSet<T: RawRepresentable & Hashable> {
//    var value: Set<T>
//}
//
//final class FieldSet<V: Selectable & RawRepresentable & Hashable>: Selectable, Equatable, Hashable {
//    typealias T = V
//    
//    var wrapper: WrapperSet<V>
//    
//    init(_ wrapper: WrapperSet<V>) {
//        self.wrapper = wrapper
//    }
//    
//    static func == (lhs: FieldSet<V>, rhs: FieldSet<V>) -> Bool {
//        lhs == rhs
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(wrapper.value.hashValue)
//    }
//}

//struct Field<E: RawRepresentable & Hashable & Selectable>: Selectable, Equatable, Hashable {
//    typealias T = E
//    var value: E
//    
//    init(_ value: E) {
//        self.value = value
//    }
//}

//protocol Selectable: Identifiable, Hashable, RawRepresentable,
//                        CaseIterable where AllCases == Array<Self> {
//    associatedtype T
//    var rawValue: String { get }
//}
//
//final class FieldWrapper<T: Selectable>: Hashable, Equatable {
//    var value: T
//    
//    init(_ value: T) {
//        self.value = value
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(value)
//    }
//    
//    static func == (lhs: FieldWrapper<T>, rhs: FieldWrapper<T>) -> Bool {
//        lhs.value.rawValue == rhs.value.rawValue
//    }
//}
