//
//  AuthNetworkSessionManager.swift
//  Authentication Module
//
//  Created by Oleh Kudinov on 07.12.19.
//

// Authentication Module code

import Alamofire

// NOTE: - We create this wrapper to not expose the use of Alomafire to others (modules and App)
public struct AuthNetworkRequest {
    let request: DataRequest

    public func cancel() {
        request.cancel()
    }
}

public final class AuthNetworkSessionManager {
    private let sessionManager: Session
    private let authHandler = AuthHandler()

    // TODO: - create and inject AuthConfiguration and AuthDelegate to notify when login is needed
    public init(sessionManager: Session = .default) {
        self.sessionManager = sessionManager
    }

    public func authRequest(_ request: URLRequest,
                            completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> AuthNetworkRequest {

        let request = sessionManager.request(request, interceptor: authHandler)
            .validate(statusCode: 200..<400)
            .response { response in
                completion(response.data, response.response, response.error)
            }
        return AuthNetworkRequest(request: request)
    }
}

final class AuthHandler: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping @Sendable (Result<URLRequest, any Error>) -> Void) {
        // TODO: - add Bearer access token to header of request, getting it from CredentialsStorageKeyChain
        completion(.success(urlRequest))
    }

    func retry(_ request: Request,
               for session: Session,
               dueTo error: any Error,
               completion: @escaping @Sendable (RetryResult) -> Void) {
        // TODO: - refresh access token if expired using lock or access queue
        completion(.doNotRetry)
    }
}
