//
//  FilterModel.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 04.01.2025.
//

import SwiftUI

struct FilterModel {
    var active: Set<SzukajRoot.Fields> = []
    var isOpenFullSearch = false
    var isTapTextSearch = false
    
    var bigSelectedEnumValue: bigSelect = .it
    var isBigTap = false
    
    enum bigSelect: sliderEnum {
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
        
        static func get(_ category: Self) -> Int {
            switch category {
            case .it:
                Szukaj.fakeNumbers[1]
            case .fiz:
                Szukaj.fakeNumbers[2]
            }
        }
        
        var id: Self {
            self
        }
    }
}
