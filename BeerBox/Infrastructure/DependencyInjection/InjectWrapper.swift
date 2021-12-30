//
//  InjectWrapper.swift
//  BeerBox
//
//  Created by Gabriele Pavanello on 27/12/21.
//

import Foundation

@propertyWrapper
class Inject<Value> {
    private var storage: Value?

    var wrappedValue: Value {
        storage ?? {
            guard let resolver = InjectSettings.resolver else {
                fatalError("container resolver not set")
            }
            guard let value = resolver.resolve(Value.self) else {
                fatalError("object \(Value.self) not set")
            }
            storage = value
            return value
        }()
    }
}
