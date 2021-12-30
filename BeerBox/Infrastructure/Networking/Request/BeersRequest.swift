//
//  BeersRequest.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation

struct BeersRequest: RequestAPI {
    let filter: [FilterType : Any]
    
    var path: String = ""
    var fixedFullPath: String? = Environment.endpoint()
    var method: APIHTTPMethod = .get
    var customHeaders: [String : String] = [:]
    var queryParameters: [String : String] = [:]
    var bodyParameters: [String : Any]? = nil
    var useMockWithName: String? = nil
    
    init(filter: [FilterType : Any], page: Int) {
        self.filter = filter
        var query: [String: String] = ["page" : "\(page)"]
        
        filter.keys.forEach {
            switch $0 {
            case .text:
                if let text = filter[$0] as? String {
                    query["beer_name"] = text
                        .replacingOccurrences(of: " ", with: "_")
                        .replacingOccurrences(of: "\n", with: "_")
                }
            case .food:
                if let food = filter[$0] as? FoodTypes {
                    query["food"] = food.rawValue
                        .replacingOccurrences(of: " ", with: "_")
                        .replacingOccurrences(of: "\n", with: "_")
                }
            }
        }
        
        self.queryParameters = query
    }
}
