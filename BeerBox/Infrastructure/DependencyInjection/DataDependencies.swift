//
//  DataDependencies.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 27/12/21.
//

import Foundation
import Swinject

class DataDependencies: InjectableDependecy {
    func registerComponents(container: Container) {
        container.register(NetworkingDataSourceInterface.self) { _ in
            NetworkingDataSource()
        }
        container.register(BeersRepositoryInterface.self) { _ in
            BeerRepository()
        }
    }
}
