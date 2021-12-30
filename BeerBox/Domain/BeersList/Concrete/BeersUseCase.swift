//
//  BeersUseCase.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 27/12/21.
//

import Foundation
import Combine

enum ErrorType: Error {
    case maxPagesReached
    case networkError
}

///Encapsulates a filter provided in input to the *BeersUseCaseInterface*
fileprivate struct ActiveFilter: Equatable {
    let filters: [FilterType : Any]
    let loadedPages: Int
    let maxPages: Bool
    
    static func == (lhs: ActiveFilter, rhs: ActiveFilter) -> Bool {
        for key in lhs.filters.keys {
            if let valRhs = rhs.filters[key] {
                switch key{
                case .text:
                    let valueLhs = lhs.filters[key] as? String
                    let valueRhs = valRhs as? String
                    if valueLhs != valueRhs {
                        return false
                    }
                case .food:
                    let valueLhs = lhs.filters[key] as? String
                    let valueRhs = valRhs as? String
                    if valueLhs != valueRhs {
                        return false
                    }
                }
            } else {
                return false
            }
        }
        return true
    }
    
    func setFilter(_ filter: FilterType, value: Any) -> ActiveFilter {
        var newfilters = filters
        newfilters[filter] = value
        return ActiveFilter(filters: newfilters, loadedPages: 0, maxPages: false)
    }
    
    func removeFilter(_ filter: FilterType) -> ActiveFilter {
        var newfilters = filters
        newfilters.removeValue(forKey: filter)
        return ActiveFilter(filters: newfilters, loadedPages: 0, maxPages: false)
    }
    
    func setLoadedPages(_ value: Int) -> ActiveFilter {
        ActiveFilter(filters: filters, loadedPages: value, maxPages: maxPages)
    }
    
    func setMaxPages() -> ActiveFilter {
        ActiveFilter(filters: filters, loadedPages: loadedPages, maxPages: true)
    }
    
    func hasSearchText() -> Bool {
        filters[.text] != nil
    }
    
    func newPage() -> Int {
        loadedPages + 1
    }
    
    static func noFilter() -> ActiveFilter {
        ActiveFilter(filters: [:], loadedPages: 0, maxPages: false)
    }
}

class BeerUseCase: BeerUseCaseInterface {
    private var listBeers: Set<BeerModel> = []
    private var listBeersPublisher: CurrentValueSubject<[BeerModel], Never> = CurrentValueSubject([])
    private var activeFilters: CurrentValueSubject<ActiveFilter, Never> = CurrentValueSubject<ActiveFilter, Never>(ActiveFilter.noFilter())
    private var errorSubject: PassthroughSubject<ErrorType, Never> = PassthroughSubject()
    
    private var disposables: Set<AnyCancellable> = []
    
    @Inject private var repository: BeersRepositoryInterface
    
    private struct Constants {
        static let pageSize = 25
    }
    
    func clearFilter() {
        activeFilters.send(ActiveFilter.noFilter())
    }
    
    func beers() -> AnyPublisher<[BeerModel], Never> {
        listBeersPublisher.map {
            $0.sorted { b1, b2 in
                b1.id < b2.id
            }
        }.eraseToAnyPublisher()
    }
    
    func pagesDownloaded() -> AnyPublisher<Int, Never> {
        activeFilters.map {
            $0.loadedPages
        }.eraseToAnyPublisher()
    }
    
    func reachedMaxPages() -> AnyPublisher<Bool, Never> {
        activeFilters.map {
            $0.maxPages
        }.eraseToAnyPublisher()
    }
    
    func setFilter(filter: FilterType, value: Any) -> AnyPublisher<Void, Never> {
        return activeFilters
            .first()
            .map {[weak self] current in
                self?.activeFilters.send(current.setFilter(filter,value: value))
            }
            .eraseToAnyPublisher()
    }
    
    func removeFilter(filter: FilterType) -> AnyPublisher<Void, Never> {
        return activeFilters
            .first()
            .map {[weak self] current in
                self?.activeFilters.send(current.removeFilter(filter))
            }
            .eraseToAnyPublisher()
    }
    
    func loadBeers() -> AnyPublisher<Void, Never> {
        return activeFilters
            .first()
            .flatMap {[weak self] filter -> AnyPublisher<Void, Error> in
                guard let self = self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                guard !filter.maxPages else {
                    return Fail(error: ErrorType.maxPagesReached).eraseToAnyPublisher()
                }
                
                let newPage = filter.newPage()
    
                return self.repository
                    .getBeers(filters: filter.filters, page: newPage)
                    .retry(1)
                    .mapError { _ in ErrorType.networkError }
                    .map { beers -> Void in
                        let models = self.createModel(beers)
                        let maxPages = models.isEmpty || models.count < Constants.pageSize
                        
                        if !models.isEmpty {
                            if newPage == 1 {
                                //It's a new filter serch, remove old results
                                self.listBeers.removeAll()
                            }
                            self.listBeers = self.listBeers.union(models)
                        } else if filter.hasSearchText() {
                            self.listBeers.removeAll()
                        }
                        
                        var newFilter = filter.setLoadedPages(newPage)
                        if maxPages {
                            newFilter = newFilter.setMaxPages()
                        }
                        
                        self.activeFilters.send(newFilter)
                        self.listBeersPublisher.send(Array(self.listBeers))
                    }
                    .eraseToAnyPublisher()
            }
            .catch({ error -> AnyPublisher<Void, Never> in
                if let error = error as? ErrorType {
                    self.errorSubject.send(error)
                }
                return Just(()).eraseToAnyPublisher()
            })
            .eraseToAnyPublisher()
    }
    
    func notifyError() -> AnyPublisher<ErrorType, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private func createModel(_ beers: Beers) -> [BeerModel] {
        beers.map { beer in
            BeerModel(id: beer.id,
                      title: beer.name,
                      subtitle: beer.tagline,
                      description: beer.dataSampleDescription,
                      imageUrl: beer.imageURL)
        }
    }
}
