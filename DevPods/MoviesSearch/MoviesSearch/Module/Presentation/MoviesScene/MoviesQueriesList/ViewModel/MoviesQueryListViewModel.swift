//
//  MoviesQueryListViewModel.swift
//  App
//
//  Created by Oleh on 03.10.18.
//

import Foundation

struct MoviesQueryListViewModelClosures {
    var selectMovieQuery: (MovieQuery) -> Void
}

protocol MoviesQueryListViewModelInput {
    func viewWillAppear()
    func didSelect(item: MoviesQueryListItemViewModel)
}

protocol MoviesQueryListViewModelOutput {
    var items: Observable<[MoviesQueryListItemViewModel]> { get }
}

protocol MoviesQueryListViewModel: MoviesQueryListViewModelInput, MoviesQueryListViewModelOutput { }

final class DefaultMoviesQueryListViewModel: MoviesQueryListViewModel {

    private let numberOfQueriesToShow: Int
    private let fetchRecentMovieQueriesUseCase: FetchRecentMovieQueriesUseCase
    private let closures: MoviesQueryListViewModelClosures?
    
    // MARK: - OUTPUT
    let items: Observable<[MoviesQueryListItemViewModel]> = Observable([])
    
    init(numberOfQueriesToShow: Int,
         fetchRecentMovieQueriesUseCase: FetchRecentMovieQueriesUseCase,
         closures: MoviesQueryListViewModelClosures? = nil) {
        self.numberOfQueriesToShow = numberOfQueriesToShow
        self.fetchRecentMovieQueriesUseCase = fetchRecentMovieQueriesUseCase
        self.closures = closures
    }
    
    private func updateMoviesQueries() {
        let request = FetchRecentMovieQueriesUseCaseRequestValue(maxCount: numberOfQueriesToShow)
        _ = fetchRecentMovieQueriesUseCase.execute(requestValue: request) { [weak self] result in
            switch result {
            case .success(let items):
                self?.items.value = items.map { $0.query }.map(MoviesQueryListItemViewModel.init)
            case .failure: break
            }
        }
    }
}

// MARK: - INPUT. View event methods
extension DefaultMoviesQueryListViewModel {
        
    func viewWillAppear() {
        updateMoviesQueries()
    }
    
    func didSelect(item: MoviesQueryListItemViewModel) {
        closures?.selectMovieQuery(MovieQuery(query: item.query))
    }
}
