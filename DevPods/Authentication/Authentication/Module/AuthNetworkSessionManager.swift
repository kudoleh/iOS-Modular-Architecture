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
    private let sessionManager: SessionManager
    private let authHandler = AuthHandler()

    // TODO: - create and inject AuthConfiguration and AuthDelegate to notify when login is needed
    public init(sessionManager: SessionManager = SessionManager()) {
        self.sessionManager = sessionManager
        sessionManager.adapter = authHandler
        sessionManager.retrier = authHandler
    }

    public func authRequest(_ request: URLRequest,
                            completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> AuthNetworkRequest {

        let request = sessionManager.request(request)
            .validate(statusCode: 200..<400)
            .response { response in
                completion(response.data, response.response, response.error)
            }
        return AuthNetworkRequest(request: request)
    }
}

final class AuthHandler: RequestAdapter, RequestRetrier {
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        // TODO: - add Bearer access token to header of request, getting it from CredentialsStorageKeyChain
        return urlRequest
    }

    func should(_ manager: SessionManager,
                retry request: Request, with error: Error,
                completion: @escaping RequestRetryCompletion) {
        // TODO: - refresh access token if expired using lock or access queue
    }
}
