//
//  DIContainer.swift
//  App
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Networking
import Authentication
import MoviesSearch

final class AppDIContainer {
    
    lazy var appConfigurations = AppConfigurations()
    
    // MARK: - Modules of Features
    lazy var moviesSearchModule: MoviesSearch.Module = {
        let dependencies = MoviesSearch.Dependencies(apiDataTransferService: apiDataTransferService,
                                                     imageDataTransferService: imageDataTransferService)
        return MoviesSearch.Module(dependencies: dependencies)
    }()
    
    // MARK: - Network
    lazy var sessionManager = AuthNetworkSessionManager()
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfigurations.apiBaseURL)!,
                                          queryParameters: ["api_key": appConfigurations.apiKey,
                                                            "language": NSLocale.preferredLanguages.first ?? "en"])
        
        let apiDataNetwork = DefaultNetworkService(config: config,
                                                   sessionManager: sessionManager)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    lazy var imageDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfigurations.imagesBaseURL)!)
        let imagesDataNetwork = DefaultNetworkService(config: config,
                                                      sessionManager: sessionManager)
        return DefaultDataTransferService(with: imagesDataNetwork)
    }()
}

// MARK: - Authentication conformance to Networking Service Protocols
extension AuthNetworkRequest: NetworkCancellable {}
extension AuthNetworkSessionManager: NetworkSessionManager {
    public func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        return authRequest(request, completion: completion)
    }
}
