//
//  FieldElemStorage.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 19.02.2025.
//

import Foundation

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
    
    struct Val<E: FieldElement>: ConfirmFEValues {
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
