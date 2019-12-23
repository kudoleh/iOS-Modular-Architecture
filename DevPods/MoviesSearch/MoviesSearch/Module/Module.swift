//
//  MoviesSearchModule.swift
//  MoviesSearch
//
//  Created by Oleh Kudinov on 23.12.19.
//

import Networking

public struct ModuleDependencies {
    let apiDataTransferService: DataTransferService
    let imageDataTransferService: DataTransferService
    
    public init (apiDataTransferService: DataTransferService, imageDataTransferService: DataTransferService) {
        self.apiDataTransferService = apiDataTransferService
        self.imageDataTransferService = imageDataTransferService
    }
}

public struct Module {
    
    private let diContainer: DIContainer
    
    public init(dependencies: ModuleDependencies) {
        self.diContainer = DIContainer(dependencies: dependencies)
    }
    
    // Note: we return UIViewController and not concrete class like MoviesListViewController
    public func startMoviesSearch() -> UIViewController {
        return self.diContainer.makeMoviesListViewController()
    }
}

// Note: We can create MoviesSearchModuleDelegate and add it to Dependencies struct if we want to delegate Chat feature to App,
// and avoid Chat module dependency form this module
public protocol ModuleDelegate: class {
    func openChatForUser(inView: UIViewController)
}
