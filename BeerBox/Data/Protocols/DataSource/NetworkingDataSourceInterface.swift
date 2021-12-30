//
//  NetworkingDataSourceInterface.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 16/12/21.
//

import Foundation
import Combine

///The protocol of the Data Source which owns the execution of REST API request.
protocol NetworkingDataSourceInterface {
    ///Performs an API request
    ///- Parameter request Encapsulate all the information to execute an API request toward the Cloud.
    ///- Returns The response of the request, otherwise an error.
    func perform(request: RequestAPI) -> AnyPublisher<APIResponse, Error>
}
