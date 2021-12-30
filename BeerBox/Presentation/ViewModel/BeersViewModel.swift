//
//  File.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation
import SwiftUI
import Combine

class BeersViewModel: ObservableObject {
    
    @Published var beers: [BeerModel] = []
    @Published var searchText: String = ""
    @Published var isEditing: Bool = false
    
    @Published var selectedFoodFilter: FoodTypes? = nil
    @Published var reachedMaxPages: Bool = false
    @Published var loadPage: Bool = false
    @Published var isLoading: Bool = false
    @Published var filterChanged: (() -> Void)? = nil
    
    @Published var showErrorAlert: Bool = false
    
    private var currentFilter: CurrentValueSubject<AnyPublisher<Void, Never>?, Never> = CurrentValueSubject(nil)
    
    private let loadPageSubject: PassthroughSubject<Void,Never> = PassthroughSubject()
    private var disposables: Set<AnyCancellable> = []
    var ignoreReload: Bool = false
    
    @Inject private var beersUseCase: BeerUseCaseInterface
    
    init() {
        $loadPage
            .map { load -> AnyPublisher<Void, Never> in
                self.beersUseCase
                    .loadBeers()
                    .replaceError(with: ())
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .sink { completon in
                switch completon {
                case .failure(let error):
                    print(error)
                default:break
                }
            } receiveValue: { _ in
                
            }.store(in: &disposables)
            
        beersUseCase
            .beers()
            .receive(on: DispatchQueue.main)
            .assign(to: &$beers)
        
        searchTextPublisher()
            .sink { _ in
            
            }.store(in: &disposables)
        
        
        $selectedFoodFilter
            .sink { [weak self] foodType in
                if let food = foodType {
                    self?.setFilter(.food, value: food)
                } else {
                    self?.removeFilter(filter: .food)
                }
                self?.loadPage = true
                self?.filterChanged?()
            }.store(in: &disposables)
        
        
        beersUseCase
            .notifyError()
            .receive(on: DispatchQueue.main)
            .map { error -> Bool in
                switch error {
                case .networkError: return true
                default: return false
                }
            }.assign(to: &$showErrorAlert)
    }
    
    private func clear() {
        beersUseCase.clearFilter()
    }
    
    func setFilter(_ filter: FilterType, value: Any) {
        ignoreReload = true
        beersUseCase
            .setFilter(filter: filter,value: value)
            .sink { _ in
                
            }.store(in: &disposables)
    }
    
    func removeFilter(filter: FilterType) {
        ignoreReload = true
        beersUseCase
            .removeFilter(filter: filter)
            .sink { _ in
                
            }.store(in: &disposables)
    }

    private func searchTextPublisher() -> AnyPublisher<Void, Never> {
        $searchText
            .map{ $0.lowercased() }
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main, options: nil)
            .flatMap {[weak self] text -> AnyPublisher<Void, Never> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                guard !text.isEmpty else {
                    return Just(())
                        .eraseToAnyPublisher()
                }
                
                return self.beersUseCase
                    .setFilter(filter: .text, value: text)
                    .flatMap { _ -> AnyPublisher<Void, Never> in
                        self.isLoading = true
                        return self.beersUseCase.loadBeers()
                            .replaceError(with: ())
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { _ in
                self.filterChanged?()
                self.isLoading = false
            })
            .eraseToAnyPublisher()
    }
}
