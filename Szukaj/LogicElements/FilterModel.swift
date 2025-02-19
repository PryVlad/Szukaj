//
//  FilterModel.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 04.01.2025.
//

import SwiftUI

struct FilterModel {
    typealias STAN = SzukajRoot.Offer.poziomStanowiska

    var active: Set<SzukajRoot.Fields> = [] {
        didSet {
            if let temp = bigCasesCheck {
                selectTab(temp)
            }
        }
    }
    
    var isOpenFullSearch = false
    var isTapTextSearch = false
    
    var bigSelectedEnumValue: bigSliderCases = .it
    var isBigFilterActiveTab = false
    
    private let itCases: Set<STAN> = [.junior, .MID, .senior]
    
    
    mutating func updateBigFilter(_ enumCase: FilterModel.bigSliderCases) {
        var exist = false
        selectTab(enumCase)
        if bigCasesCheck == enumCase {
            exist = true
        }
        active.removeAll()
        
        if !exist {
            switch enumCase {
            case .fiz:
                active = [.stan(.init( [.fizyczny] ))]
            case .it:
                active = [.stan(.init( itCases ))]
            }
        }
    }
    
    
    private var bigCasesCheck: bigSliderCases? {
        if active == [.stan(.init( [.fizyczny] ))] {
            return .fiz
        }
        if active == [.stan(.init( itCases ))] {
            return .it
        }
        return nil
    }
    
    private mutating func selectTab(_ val: bigSliderCases) {
        if bigSelectedEnumValue == val {
            isBigFilterActiveTab.toggle()
        } else {
            isBigFilterActiveTab = true
        }
        bigSelectedEnumValue = val
    }
    
    enum bigSliderCases: sliderEnum {
        case it, fiz
        
        static private let lib = [
            Self.it : ["IT", "desktopcomputer"],
            Self.fiz : ["Praca fizyczna", "wrench"]
        ]
        
        var text: String {
            Self.lib[self]![0]
        }
        
        var sysImg: String {
            Self.lib[self]![1]
        }
        
        var id: Self {
            self
        }
    }
}

protocol sliderEnum: Identifiable, Equatable, CaseIterable where AllCases == Array<Self> {
    var text: String { get }
    var sysImg: String { get }
}
