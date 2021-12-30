//
//  FoodFilterView.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation
import SwiftUI

struct FoodFilterView: View {
    @EnvironmentObject var vm: BeersViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(FoodTypes.allCases, id: \.self) { food in
                    let index = food
                    let isSelected = index == vm.selectedFoodFilter
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20.0, style: .continuous)
                            .fill(isSelected ? Colors.selectedFilterBackground : Colors.unselectedFilterBackground)
                            .frame(height: 40)
                        
                        Text("\(food.rawValue.capitalized)")
                            .foregroundColor(isSelected ? Colors.darkText : Colors.unselectedFilterText)
                            .font(.subheadline.weight(.semibold))
                            .scaledToFill()
                            .lineLimit(1)
                            .padding([.leading, .trailing], 20)
                        
                    }
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if index != vm.selectedFoodFilter {
                                vm.selectedFoodFilter = index
                            } else {
                                vm.selectedFoodFilter = nil
                            }
                        }
                    }
                }
            }
            .padding(.leading, 30)
            .padding(.trailing, 10)
        }
        .padding(.leading,-20)
    }
}
