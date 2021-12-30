//
//  BeerModel.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation

struct BeerModel: Hashable, Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let description: String
    let imageUrl: String?
}
