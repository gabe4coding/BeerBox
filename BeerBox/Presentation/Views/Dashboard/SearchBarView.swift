//
//  SearchBarView.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation
import SwiftUI

struct SearchBar: View {
    @EnvironmentObject var vm: BeersViewModel
    
    var body: some View {
        HStack {
            TextField("Search", text: $vm.searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .frame(height: 45)
                .textFieldStyle(SearchTextFieldStyle())
                .disableAutocorrection(true)
                .background(Colors.searchBarBackground)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
                        
                        if vm.isEditing {
                            Button(action: {
                                self.vm.searchText = ""
                                self.vm.removeFilter(filter: .text)
                                self.vm.loadPage = true
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        vm.isEditing = true
                    }
                }
            
            if vm.isEditing {
                Button(action: {
                    UIApplication.shared
                        .sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                    withAnimation(.easeInOut(duration: 0.2)) {
                        vm.isEditing = false
                    }
                }) {
                    Text("Cancel")
                        .foregroundColor(Colors.bgYellow)
                }
                .padding(.trailing, 10)
            }
        }
    }
}

struct SearchTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(Colors.unselectedFilterText)
            .padding()
    }
}
