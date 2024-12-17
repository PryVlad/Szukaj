//
//  SzukajApp.swift
//  Szukaj
//
//  Created by Vladyslav Pryl on 15.12.2024.
//

import SwiftUI

@main
struct SzukajApp: App {
    @StateObject var viewModel = Szukaj()
    
    var body: some Scene {
        WindowGroup {
            SzukajView(app: viewModel)
        }
    }
}
