//
//  MoviesQueriesListViewModelTests.swift
//  AppTests
//
//  Created by Oleh Kudinov on 16.08.19.
//

import XCTest
@testable import MoviesSearch

class MoviesQueriesListViewModelTests: XCTestCase {
    
    private enum FetchRecentQueriedUseCase: Error {
        case someError
    }
    
    var movieQueries = [MovieQuery(query: "query1"),
                        MovieQuery(query: "query2"),
                        MovieQuery(query: "query3"),
                        MovieQuery(query: "query4"),
                        MovieQuery(query: "query5")]
    
    class FetchRecentMovieQueriesUseCaseMock: FetchRecentMovieQueriesUseCase {
        var expectation: XCTestExpectation?
        var error: Error?
        var movieQueries: [MovieQuery] = []
        
        func execute(requestValue: FetchRecentMovieQueriesUseCaseRequestValue, completion: @escaping (Result<[MovieQuery], Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(movieQueries))
            }
            expectation?.fulfill()
            return nil
        }
    }
    
    func test_whenFetchRecentMovieQueriesUseCaseReturnsQueries_thenShowTheseQueries() {
        // given
        let useCase = FetchRecentMovieQueriesUseCaseMock()
        useCase.expectation = self.expectation(description: "Recent query fetched")
        useCase.movieQueries = movieQueries
        let viewModel = DefaultMoviesQueryListViewModel(numberOfQueriesToShow: 3,
                                                    fetchRecentMovieQueriesUseCase: useCase)

        // when
        viewModel.viewWillAppear()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.items.value.map { $0.query }, movieQueries.map { $0.query })
    }
    
    func test_whenFetchRecentMovieQueriesUseCaseReturnsError_thenDontShowAnyQuery() {
        // given
        let useCase = FetchRecentMovieQueriesUseCaseMock()
        useCase.expectation = self.expectation(description: "Recent query fetched")
        useCase.error = FetchRecentQueriedUseCase.someError
        let viewModel = DefaultMoviesQueryListViewModel(numberOfQueriesToShow: 3,
                                                        fetchRecentMovieQueriesUseCase: useCase)
        
        // when
        viewModel.viewWillAppear()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(viewModel.items.value.isEmpty)
    }
    
    func test_whenDidSelectQueryEventIsReceived_thenCallDidSelectAction() {
        // given
        let selectedQueryItem = MovieQuery(query: "query1")
        var actionMovieQuery: MovieQuery?
        let expectation = self.expectation(description: "Delegate notified")
        let didSelect: MoviesQueryListViewModelDidSelectAction = { movieQuery in
            actionMovieQuery = movieQuery
            expectation.fulfill()
        }

        let viewModel = DefaultMoviesQueryListViewModel(numberOfQueriesToShow: 3,
                                                        fetchRecentMovieQueriesUseCase: FetchRecentMovieQueriesUseCaseMock(),
                                                        didSelect: didSelect)
        
        // when
        viewModel.didSelect(item: MoviesQueryListItemViewModel(query: selectedQueryItem.query))
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actionMovieQuery, selectedQueryItem)
    }
}
