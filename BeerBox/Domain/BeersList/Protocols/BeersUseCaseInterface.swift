//
//  BeersUseCaseInterface.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 16/12/21.
//

import Foundation
import Combine

///The Use Case which handles the listing and the filtering options (text, foods) of a list of beers.
protocol BeerUseCaseInterface {
    
    ///If subscribed, observes the changes on the list of Beers, mapped in a list  of *BeerModel*
    func beers() -> AnyPublisher<[BeerModel], Never>
    
    ///Triggers a new beers update towards the repository.
    func loadBeers() -> AnyPublisher<Void, Never>
    
    ///Sets a new filter for a subsequent beers update.
    ///- Parameter filter The type of the filter related to the value provided.
    ///- Parameter value The value of the filter associated
    ///- Returns A publisher which completes immediately
    func setFilter(filter: FilterType, value: Any) -> AnyPublisher<Void, Never>
    
    ///Removes a filter for a subsequent beers update.
    ///- Returns A publisher which completes immediately
    func removeFilter(filter: FilterType) -> AnyPublisher<Void, Never>
    
    ///Clears all the filters
    func clearFilter()
    
    ///A Publisher which returns the current number of pages downloaded.
    func pagesDownloaded() -> AnyPublisher<Int, Never>
    
    ///A Publisher which informs about the reach of the maximum number of pages downloaded for the active filters.
    func reachedMaxPages() -> AnyPublisher<Bool, Never>
    
    ///Notifies for an error occurence for networking reasons (timeout, offline, etc)
    func notifyError() -> AnyPublisher<ErrorType, Never>
}
