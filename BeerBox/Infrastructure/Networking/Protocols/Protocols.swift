//
//  Protocols.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 26/12/21.
//

import Foundation

enum APIHTTPMethod: String {
    case post
    case get
    case delete
    case put
}

enum APIError: Swift.Error {
    case failedDecoding(Error?)
    case invalidUrl
    case generic(Error)
    case genericError
    case statusCode(APIResponse)
    case offline // 1009
}

protocol RequestAPI {
    var path: String { get }
    var fixedFullPath: String? { get }
    var method: APIHTTPMethod { get }
    var customHeaders: [String: String] { get }
    var queryParameters: [String: String] { get }
    var bodyParameters: [String: Any]? { get }
    var useMockWithName: String? { get }
}

struct APIResponse {
    let statusCode: Int
    var data: Data? = nil
    var response: URLResponse? = nil
    var request: URLRequest? = nil
    var error: Swift.Error? = nil

    enum StatusCodeType: Int {
        case badReqest = 400
        case unauthorized = 401
        case forbidden = 403
        case notFound = 404
        case preconditionFailed = 412
        case internalServerError = 500
        case serviceUnavailable = 503
        case invalid = -1
    }

    func statusCodeType() -> StatusCodeType {
        StatusCodeType(rawValue: statusCode) ?? .invalid
    }
}
