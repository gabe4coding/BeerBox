//
//  FilterTypes.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation

enum FoodTypes: String, CaseIterable {
    case Vegetables = "vegetables"
    case Pork = "pork"
    case Salad = "salad"
    case Chicken = "chicken"
    case Wine = "wine"
    case SoySauce = "soy sauce"
}

enum FilterType {
    case text
    case food
}

protocol Filter {
    var type: FilterType { get }
}

struct FoodFilter: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(value)
    }
    
    let type: FilterType
    let value: FoodTypes
}

struct TextFilter: Hashable {
    var type: FilterType
    var value: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(value)
    }
    
    init(type: FilterType, value: String) {
        self.type = type
        self.value = value
    }
}

