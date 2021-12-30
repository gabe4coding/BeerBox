//
//  BeersRepository.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 27/12/21.
//

import Foundation
import Combine

class BeerRepository: BeersRepositoryInterface {
    @Inject private var networking: NetworkingDataSourceInterface
    
    func getBeers(filters: [FilterType : Any], page: Int) -> AnyPublisher<Beers, Error> {
        let request = BeersRequest(filter: filters, page: page)
        return networking.perform(request: request).decode()
    }
}
