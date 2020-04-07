//
//  FetchRecentMovieQueriesUseCase.swift
//  App
//
//  Created by Oleh Kudinov on 11.08.19.
//

import Foundation

protocol FetchRecentMovieQueriesUseCase {
    func execute(requestValue: FetchRecentMovieQueriesUseCaseRequestValue,
                 completion: @escaping (Result<[MovieQuery], Error>) -> Void) -> Cancellable?
}

final class DefaultFetchRecentMovieQueriesUseCase: FetchRecentMovieQueriesUseCase {
    
    private let moviesQueriesRepository: MoviesQueriesRepository
    
    init(moviesQueriesRepository: MoviesQueriesRepository) {
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    func execute(requestValue: FetchRecentMovieQueriesUseCaseRequestValue,
                 completion: @escaping (Result<[MovieQuery], Error>) -> Void) -> Cancellable? {

        moviesQueriesRepository.fetchRecentsQueries(maxCount: requestValue.maxCount, completion: completion)
        return nil
    }
}

struct FetchRecentMovieQueriesUseCaseRequestValue {
    let maxCount: Int
}
