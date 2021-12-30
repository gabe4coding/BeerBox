//
//  UpperRoundedRectangle.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 27/12/21.
//

import SwiftUI

struct UpperRoundedRectangle: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Colors.background)
                .frame(maxHeight: 250)
                .ignoresSafeArea()
        
            Rectangle()
                .fill(Colors.background)
                .frame(maxHeight: 200)
                .ignoresSafeArea()
                .padding(.top,50)
        }
    }
}

struct UpperRoundedRectangle_Previews: PreviewProvider {
    static var previews: some View {
        UpperRoundedRectangle()
    }
}
