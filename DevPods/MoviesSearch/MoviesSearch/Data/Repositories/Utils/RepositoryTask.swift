//
//  RepositoryTask.swift
//  App
//
//  Created by Oleh Kudinov on 25.10.19.
//

import Foundation
import Networking

struct RepositoryTask: Cancellable {
    let networkTask: NetworkCancellable?
    func cancel() {
        networkTask?.cancel()
    }
}
