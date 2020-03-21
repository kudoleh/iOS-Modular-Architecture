//
//  MoviesSearchModule.swift
//  MoviesSearch
//
//  Created by Oleh Kudinov on 23.12.19.
//

import UIKit
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
    
    // Note: We return UIViewController and not concrete class like MoviesListViewController
    public func startMoviesSearchFlow(in navigationController: UINavigationController) {
        let flow = MoviesFlowCoordinator(navigationController: navigationController,
                                         dependencies: diContainer)
        flow.start()
    }
}

// Note: We can create ChatPresenter Interface and add it to ModuleDependencies if we want to delegate
// Chat feature to App and avoid dependency on Chat module from this module(same can be done by using closure)
public protocol ChatPresenter {
    func openChatForUser(inView: UIViewController)
}
