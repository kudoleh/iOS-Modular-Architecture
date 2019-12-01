//
//  NetworkSessionManagerMock.swift
//  AppTests
//
//  Created by Oleh Kudinov on 16.08.19.
//

import Foundation
@testable import Networking

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable {
        completion(data, response, error)
        return URLSessionDataTask()
    }
}
