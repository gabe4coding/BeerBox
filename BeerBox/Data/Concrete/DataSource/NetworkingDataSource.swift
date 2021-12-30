//
//  NetworkingDataSource.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 27/12/21.
//

import Foundation
import Alamofire
import Combine

class NetworkingDataSource: NetworkingDataSourceInterface {
    private var taskSessions: [String: Session] = [:]

    func perform(request: RequestAPI) -> AnyPublisher<APIResponse, Error> {
        let session: Session
        do {
            session = try buildSession(request: request)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }

        return Just(request)
            .setFailureType(to: Error.self)
            .requestBuilder(buildBasePath: buildBasePath, defaultHeaders: buildDefaultHeaders)
            .simpleRequestHandler(using: session)
            .eraseToAnyPublisher()
    }

    func buildDefaultHeaders() -> [String: String] {
        return [:]
    }

    func buildBasePath(request: RequestAPI) -> String {
        return request.path
    }

    private func buildSession(request: RequestAPI) throws -> Session {
        let sessionKey: String = "mainSession"

        guard let savedSession = taskSessions[sessionKey] else {
            let session = Session()
            taskSessions[sessionKey] = session
            return session
        }
        
        return savedSession
    }
}
