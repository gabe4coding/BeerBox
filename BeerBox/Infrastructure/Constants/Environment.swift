//
//  Environment.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation

struct Environment {
    static let baseUrl: String = "https://api.punkapi.com"
    static let path: String = "/v2/beers"
    
    static func endpoint() -> String {
        "\(baseUrl)\(path)"
    }
}
