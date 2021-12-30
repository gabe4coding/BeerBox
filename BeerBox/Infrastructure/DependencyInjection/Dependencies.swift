//
//  Injection.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 27/12/21.
//

import Foundation
import Swinject

protocol InjectableDependecy {
    func registerComponents(container: Container)
}

struct InjectSettings {
    static var resolver: Resolver?
}

class Dependecies {
    let container: Container

    init(customContainer: Container? = nil) {
        container = customContainer ?? Container()
    }

    func registerComponents() {
        let dependecies: [InjectableDependecy] = [DataDependencies(), UseCasesDependencies()]
        dependecies.forEach { [weak self] in
            guard let self = self else { return }
            $0.registerComponents(container: self.container)
        }
    }

    func register<T>(type: T.Type, factory: @escaping (Resolver) -> T) {
        container.register(type, factory: factory)
    }
}
