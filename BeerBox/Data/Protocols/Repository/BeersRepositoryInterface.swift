//
//  BeersRepositoryInterface.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation
import Combine

///The repository which handles the requests for new beers from the Cloud
protocol BeersRepositoryInterface {
    
    ///Builds the request with filtering towards the Networking Data Souce
    ///- Parameter filters The optional filters for the beers request. The dictionary can be empty.
    ///- Parameter page The page number of the request for pagination strategy
    ///- Returns A publisher which provide the *Beers*, an *Error* otherwise.
    func getBeers(filters: [FilterType : Any], page: Int) -> AnyPublisher<Beers, Error>
}

