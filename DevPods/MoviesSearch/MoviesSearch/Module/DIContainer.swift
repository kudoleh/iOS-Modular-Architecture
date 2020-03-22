//
//  DIContainer.swift
//  App
//
//  Created by Oleh Kudinov on 03.03.19.
//

import UIKit
import SwiftUI
import Networking

final class DIContainer {
    
    private let dependencies: ModuleDependencies

    // MARK: - Persistent Storage
    lazy var moviesQueriesStorage: MoviesQueriesStorage = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
    
    init(dependencies: ModuleDependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        return DefaultSearchMoviesUseCase(moviesRepository: makeMoviesRepository(),
                                          moviesQueriesRepository: makeMoviesQueriesRepository())
    }
    
    func makeFetchRecentMovieQueriesUseCase() -> FetchRecentMovieQueriesUseCase {
        return DefaultFetchRecentMovieQueriesUseCase(moviesQueriesRepository: makeMoviesQueriesRepository())
    }
    
    // MARK: - Repositories
    func makeMoviesRepository() -> MoviesRepository {
        return DefaultMoviesRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    func makeMoviesQueriesRepository() -> MoviesQueriesRepository {
        return DefaultMoviesQueriesRepository(dataTransferService: dependencies.apiDataTransferService,
                                              moviesQueriesPersistentStorage: moviesQueriesStorage)
    }
    func makePosterImagesRepository() -> PosterImagesRepository {
        
        return DefaultPosterImagesRepository(dataTransferService: dependencies.imageDataTransferService,
                                             imageNotFoundData: (#imageLiteral(resourceName: "image_not_found") as LiteralBundleImage).image?.pngData())
    }
    
    // MARK: - Movies List
    func makeMoviesListViewController() -> MoviesListViewController {
        return MoviesListViewController.create(with: makeMoviesListViewModel(),
                                               posterImagesRepository: makePosterImagesRepository())
    }
    
    func makeMoviesListViewModel() -> MoviesListViewModel {
        return DefaultMoviesListViewModel(searchMoviesUseCase: makeSearchMoviesUseCase())
    }
    
    // MARK: - Movie Details
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController {
        return MovieDetailsViewController.create(with: makeMoviesDetailsViewModel(movie: movie))
    }
    
    func makeMoviesDetailsViewModel(movie: Movie) -> MovieDetailsViewModel {
        return DefaultMovieDetailsViewModel(movie: movie,
                                            posterImagesRepository: makePosterImagesRepository())
    }
    
    // MARK: - Movies Queries Suggestions List
    func makeMoviesQueriesSuggestionsListViewController(delegate: MoviesQueryListViewModelDelegate) -> UIViewController {
        if #available(iOS 13.0, *) { // SwiftUI
            let view = MoviesQueryListView(viewModelWrapper: makeMoviesQueryListViewModelWrapper(delegate: delegate))
            return UIHostingController(rootView: view)
        } else { // UIKit
            return MoviesQueriesTableViewController.create(with: makeMoviesQueryListViewModel(delegate: delegate))
        }
    }
    
    func makeMoviesQueryListViewModel(delegate: MoviesQueryListViewModelDelegate) -> MoviesQueryListViewModel {
        return DefaultMoviesQueryListViewModel(numberOfQueriesToShow: 10,
                                               fetchRecentMovieQueriesUseCase: makeFetchRecentMovieQueriesUseCase(),
                                               delegate: delegate)
    }

    @available(iOS 13.0, *)
    func makeMoviesQueryListViewModelWrapper(delegate: MoviesQueryListViewModelDelegate) -> MoviesQueryListViewModelWrapper {
        return MoviesQueryListViewModelWrapper(viewModel: makeMoviesQueryListViewModel(delegate: delegate))
    }

    // MARK: - Flow Coordinators
    func makeMoviesSearchFlowCoordinator(navigationController: UINavigationController) -> MoviesSearchFlowCoordinator {
        return MoviesSearchFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }
}

extension DIContainer: MoviesSearchFlowCoordinatorDependencies {}
