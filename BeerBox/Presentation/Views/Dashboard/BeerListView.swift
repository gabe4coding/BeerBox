//
//  BeerListView.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation
import SwiftUI

struct BeerListView: View {
    @EnvironmentObject var vm: BeersViewModel
    @ObservedObject var keyboardResponder = KeyboardResponder()
    
    @State var height: CGFloat = 0
    @Binding var showDetail: Bool
    @Binding var detailModel: BeerModel?
    
    var body: some View {
        GeometryReader { proxy in
            ScrollViewReader { reader in
                List {
                    if vm.beers.isEmpty {
                        Text("No results available")
                            .foregroundColor(Colors.bgYellow)
                            .font(.body.weight(.semibold))
                            .listRowBackground(Colors.background)
                            .listRowInsets(EdgeInsets())
                            .frame(maxWidth:.infinity)
                            .listRowSeparator(.hidden)
                            .padding()
                            
                    } else {
                        ForEach(vm.beers.indices, id: \.self) { index in
                            BeerCellView(model: vm.beers[index],
                                         detailModel:$detailModel,
                                         showDetail: $showDetail)
                                .listRowInsets(EdgeInsets())
                                .id(index)
                        }
                        .listRowBackground(Colors.background)
                        
                        ZStack {
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                            Rectangle()
                                .opacity(0.0)
                                .frame(height: vm.isLoading ? 50 : 1)
                                .onAppear {
                                    vm.loadPage = true
                                }
                        }
                        .listRowBackground(Colors.background)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .onAppear(perform: {
                    height = proxy.size.height
                    vm.filterChanged = { reader.scrollTo(0) }
                })
                .frame(maxHeight: height - keyboardResponder.currentHeight * 0.9 + 150)
            }
        }
    }
}
