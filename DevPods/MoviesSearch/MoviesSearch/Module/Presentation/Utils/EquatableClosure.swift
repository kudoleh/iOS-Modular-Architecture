//
//  EquatableClosure.swift
//  MoviesSearch
//
//  Created by Oleh Kudinov on 06/04/2020.
//

import Foundation

@propertyWrapper
struct EquatableClosure: Equatable {

    typealias Closure = () -> Void
    var wrappedValue: Closure

    init(wrappedValue: @escaping Closure) {
        self.wrappedValue = wrappedValue
    }

    static func == (lhs: EquatableClosure, rhs: EquatableClosure) -> Bool {
        true
    }
}
