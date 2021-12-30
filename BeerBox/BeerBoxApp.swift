//
//  BeerBoxApp.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 16/12/21.
//

import SwiftUI

@main
struct BeerBoxApp: App {
    let dp = Dependecies()
    
    init() {
        InjectSettings.resolver = dp.container
        dp.registerComponents()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(BeersViewModel())
        }
    }
}
