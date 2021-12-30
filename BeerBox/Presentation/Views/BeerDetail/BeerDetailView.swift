//
//  BeerDetailView.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import SwiftUI
import CachedAsyncImage

struct BeerDetailView: View {
    @Binding var model: BeerModel?
    @EnvironmentObject var vm: BeersViewModel
    @State private var viewHeight = CGFloat.zero
    @State private var appeared = false
    @Binding var showing: Bool
    
    var body: some View {
        ZStack {
            if appeared {
                Color.black.opacity(0.5).ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            appeared = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showing = false
                            }
                        }
                    }
                
                VStack {
                    Spacer()
                    ZStack(alignment: .topTrailing) {
                        UpperRoundedRectangle()
                            .background(GeometryReader {
                                Color.clear.preference(key: ViewHeightKey.self,
                                    value: $0.frame(in: .local).size.height)
                            })
                        
                        BookmarkView()
                            .frame(width: 30, height: 30)
                            .padding(.trailing, 25)
                        
                        HStack(alignment:.center, spacing: 10) {
                            if model?.imageUrl == nil {
                                Image(model?.imageUrl ?? "default_beer")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth:80, maxHeight:self.viewHeight * 0.7)
                                    .cornerRadius(5.0)
                                    .padding(5)
                            } else {
                                CachedAsyncImage(url: URL(string: model?.imageUrl ?? "")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    ShimmerView(maxWidth: 80)
                                }
                                .frame(maxWidth:80, maxHeight:self.viewHeight * 0.65)
                                .cornerRadius(5.0)
                            }
                
                            VStack(alignment: .leading) {
                                Text(model?.title ?? "")
                                    .font(.title3.weight(.bold))
                                    .foregroundColor(.white)
                                    .lineLimit(2)
                                
                                Text(model?.subtitle ?? "")
                                    .font(.system(size: 16))
                                    .foregroundColor(Colors.lightText)
                                    .lineLimit(2)
                                   
                                VStack {
                                    ScrollView {
                                    Text(model?.description ?? "")
                                        .font(.system(size: 15))
                                        .foregroundColor(Colors.lightText)
                                        .padding(.bottom, 20)
                                        
                                    }.frame(maxHeight: self.viewHeight)
                                }
                            }
                            .frame(alignment: .leading)
                            .padding([.top], 40)
                        }
                        .frame(maxWidth:.infinity, maxHeight: self.viewHeight)
                        .padding([.leading, .trailing], 20)
                    }
                }
                .onPreferenceChange(ViewHeightKey.self) {
                    self.viewHeight = $0
                }
                .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                .ignoresSafeArea()
            }
        }.onAppear(perform: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                appeared = true
            }
        })
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct ViewWidthKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

struct BeerDetailView_Previews: PreviewProvider {
    
    @State static var showing: Bool = true
    @State static var model: BeerModel? = BeerModel(id: 1, title: "Buzzaaadasdadas", subtitle: "A Real Bitter Experience.", description: "A light, crisp and only once.", imageUrl: "https://images.punkapi.com/v2/keg.png")
    
    static var previews: some View {
        Group {
            BeerDetailView(model: $model, showing: $showing)
            BeerDetailView(model: $model, showing: $showing)
        }
    }
}
