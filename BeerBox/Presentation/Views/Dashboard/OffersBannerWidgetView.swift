//
//  OffersBannerWidgetView.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation
import SwiftUI

struct OffersBannerWidget: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Colors.bgYellow)
                .frame(height: 70, alignment: .center)
                .cornerRadius(10)
            HStack(spacing:0) {
                VStack {
                    Text("Weekend Offers")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(Colors.darkText)
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                    Text("Free shipping on orders over 60€")
                        .font(.subheadline.weight(.light))
                        .foregroundColor(Colors.darkText)
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .padding(.leading, 20)
                
                VStack(alignment: .trailing) {
                    Image("img")
                        .padding( .trailing, 15)
                }
            }
        }
        .padding(10)
    }
}
