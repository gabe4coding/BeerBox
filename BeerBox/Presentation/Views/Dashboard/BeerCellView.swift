//
//  BeerCellView.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation
import SwiftUI
import CachedAsyncImage

struct BeerCellView: View {
    
    let model: BeerModel
    @Binding var detailModel: BeerModel?
    @Binding var showDetail: Bool
    
    private struct Constants {
        static let cellHeight: CGFloat = 170
        static let imageWidth: CGFloat = 50
        static let imageHeight: CGFloat = imageWidth * 3
        static let fontSize: CGFloat = 16
        static let defaultBeerImg = "default_beer"
    }
    
    var body: some View {
        VStack(alignment:.leading) {
            HStack(alignment:.center) {
                if let url = model.imageUrl {
                    CachedAsyncImage(url: URL(string: url), urlCache: .imageCache) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Constants.imageWidth)
                    } placeholder: {
                        ShimmerView(maxWidth: Constants.imageWidth)
                    }
                    .padding(.trailing, 10)
                    
                } else {
                    Image(Constants.defaultBeerImg)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth:Constants.imageWidth,
                               maxHeight: Constants.imageHeight)
                        .cornerRadius(5.0)
                        .padding(5)
                }
                
                VStack(alignment: .leading) {
                    Text(model.title)
                        .font(.title3.weight(.bold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(model.subtitle)
                        .font(.system(size: Constants.fontSize))
                        .foregroundColor(Colors.lightText)
                        .lineLimit(1)
                        .padding(.bottom, 10)
                    
                    Text(model.description)
                        .font(.system(size: Constants.fontSize))
                        .foregroundColor(Colors.lightText)
                        .lineLimit(2)
                    
                    Button("More Info".uppercased()) {
                        UIApplication.shared
                            .sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
                        
                        detailModel = model
                        withAnimation {
                            showDetail.toggle()
                        }
                        
                    }.foregroundColor(Colors.bgYellow)
                        .font(.system(size: Constants.fontSize).weight(.semibold))
                }
            }
            .padding()
        }
        .frame(height: Constants.cellHeight)
    }
}


