//
//  UseCaseDependencies.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 27/12/21.
//

import Foundation
import Swinject

class UseCasesDependencies: InjectableDependecy {
    func registerComponents(container: Container) {
        container.register(BeerUseCaseInterface.self) { _ in
            BeerUseCase()
        }
    }
}
