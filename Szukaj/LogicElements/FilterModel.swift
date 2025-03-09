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
            } else {
                isBigFilterActiveTab = false
            }
        }
    }
    
    var isOpenFullSearch = false
    var isTapTextSearch: Bool? = false
    
    var bigSliderSelected: BigSliderCases = .it
    var isBigFilterActiveTab = false
    
    var textInput = ""
    
    private static let itCases: Set<STAN> = [.junior, .MID, .senior]
    
    
    mutating func updateBigFilter(_ enumCase: FilterModel.BigSliderCases) {
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
                active = [.stan(.init( Self.itCases ))]
            }
        }
    }
    
    
    private var bigCasesCheck: BigSliderCases? {
        if active == [.stan(.init( [.fizyczny] ))] {
            return .fiz
        }
        if active == [.stan(.init( Self.itCases ))] {
            return .it
        }
        return nil
    }
    
    private mutating func selectTab(_ val: BigSliderCases) {
        if bigSliderSelected == val {
            isBigFilterActiveTab.toggle()
        } else {
            isBigFilterActiveTab = true
        }
        bigSliderSelected = val
    }
    
    enum BigSliderCases: sliderEnum {
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
