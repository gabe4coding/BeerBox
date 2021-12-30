//
//  AppTitleView.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation
import SwiftUI

struct AppTitleView: View {
    var body: some View {
        HStack(spacing: 5) {
            Text("Beer")
                .foregroundColor(Color.white)
                .font(.largeTitle.weight(.ultraLight))
            Text("Box")
                .foregroundColor(Color.white)
                .font(.largeTitle.weight(.semibold))
        }
        .padding(10)
    }
}
