//
//  ContentView.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 16/12/21.
//

import SwiftUI
import CachedAsyncImage

struct ContentView: View {
    @State var showDetail: Bool = false
    @State var model: BeerModel? = nil
    
    @EnvironmentObject var vm: BeersViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 5) {
                AppTitleView()
                
                SearchBar().environmentObject(vm)
                
                if !vm.isEditing {
                    OffersBannerWidget()
                }
                
                FoodFilterView().environmentObject(vm)
                
                BeerListView(showDetail: $showDetail,
                             detailModel: $model).environmentObject(vm)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Colors.background)
            .alert(isPresented: $vm.showErrorAlert) {
                Alert(title: Text("Warning"),
                      message: Text("An error occured, please try again."),
                      dismissButton: .cancel())
            }
            
            if showDetail {
                BeerDetailView(model: $model, showing: $showDetail).environmentObject(vm)
            }
        }
        .preferredColorScheme(.dark)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
