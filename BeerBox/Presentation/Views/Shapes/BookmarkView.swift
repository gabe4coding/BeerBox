//
//  BookmarkView.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 27/12/21.
//

import SwiftUI

struct BookmarkView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width * 2.5
                let spacing = width * 0.030
                let middle = width * 0.5
                let topHeight = height * 0.488

                path.addLines([
                    CGPoint(x: middle * 0.1, y: 0),
                    CGPoint(x: middle * 0.1, y: topHeight - spacing),
                    CGPoint(x: middle, y: topHeight / 1.6 + spacing),
                    CGPoint(x: middle * 1.9, y: topHeight - spacing),
                    CGPoint(x: middle * 1.9, y: 0)
                ])
            }
            .fill(Colors.bgYellow)
        }
    }
}

struct BadgeSymbol_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkView()
    }
}
