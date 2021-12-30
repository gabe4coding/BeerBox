//
//  Extensions+Publisher.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 16/12/21.
//

import Foundation
import Combine
import Alamofire

extension JSONDecoder {
    static let defaultDecoder = JSONDecoder()
}

extension Publisher where Self.Output == APIResponse, Self.Failure == Error {
    func decode<T: Decodable>(as decodeOutput: T.Type = T.self,
                              using decoder: JSONDecoder = JSONDecoder.defaultDecoder) -> AnyPublisher<T, Failure> {
        receive(on: DispatchQueue.global(qos: .default))
            .flatMap { apiResponse -> AnyPublisher<T, Failure> in
                if let data = apiResponse.data {
                    do {
                        let decoded = try decoder.decode(decodeOutput, from: data)
                        return Just(decoded)
                                .setFailureType(to: Failure.self)
                                .eraseToAnyPublisher()
                    } catch {
                        return Fail(error: APIError.failedDecoding(error))
                                .eraseToAnyPublisher()
                    }
                }
                return Fail(error: APIError.failedDecoding(nil))
                        .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension Publisher where Self.Output == RequestAPI, Self.Failure == Error {
    func requestBuilder(buildBasePath: @escaping (Self.Output) -> String,
                        defaultHeaders: @escaping () -> [String: String]) -> AnyPublisher<URLRequest, Failure> {
        return flatMap { request -> AnyPublisher<URLRequest, Failure> in
            Future<URLRequest, Failure> { promise in
                // Request setup
                let urlBasePath: String
                if let builtPath: String = request.fixedFullPath {
                    urlBasePath = builtPath
                } else {
                    urlBasePath = buildBasePath(request)
                }

                var components = URLComponents(string: urlBasePath)
                let pathParameters: [String: String] = request.queryParameters
                if !pathParameters.isEmpty {
                    components?.queryItems = pathParameters.map { element in URLQueryItem(name: element.key, value: element.value) }
                }

                guard let url = components?.url else {
                    promise(Result.failure(APIError.invalidUrl))
                    return
                }
    
                var requestURL = URLRequest(url: url)
                requestURL.httpMethod = request.method.rawValue

                var headers: [String: String] = defaultHeaders()

                if let jsonModel = request.bodyParameters,
                   let jsonData = try? JSONSerialization.data(withJSONObject: jsonModel) {
                    requestURL.httpBody = jsonData
                    headers["Content-Type"] = "application/json"
                }
                
                headers.merge(request.customHeaders, uniquingKeysWith: { _, new in new })
                requestURL.allHTTPHeaderFields = headers
                requestURL.cachePolicy = .reloadIgnoringCacheData

                promise(Result.success(requestURL))
            }
            .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

extension Publisher where Self.Output == URLRequest, Self.Failure == Error {
    func simpleRequestHandler(using session: Session) -> AnyPublisher<APIResponse, Failure> {
        
        return print("Request").flatMap { requestURL -> AnyPublisher<APIResponse, Failure> in
            let task = session.request(requestURL)
            return Deferred {
                Future<APIResponse, Error> { promise in
                    task.response { result in

                        let statusCode: Int? = result.response?.statusCode
                     
                        let alamofireError = result.error
                        let reponseError = alamofireError?.underlyingError
                        if let statusCode = statusCode {
                            let apiResponse = APIResponse(statusCode: statusCode, data: result.data, response: result.response, request: requestURL, error: reponseError)
                            promise(Result.success(apiResponse))
                            return
                        } else if let error = reponseError {
                            if (error as NSError).code == -1009 {
                                promise(Result.failure(APIError.offline))
                            } else {
                                promise(Result.failure(error))
                            }
                            return
                        } else {
                            promise(Result.failure(APIError.genericError))
                        }
                    }
                    task.resume()
                }.handleEvents(receiveCancel: {
                    task.cancel()
                })

            }.subscribe(on: DispatchQueue.global(qos: .default)).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}

