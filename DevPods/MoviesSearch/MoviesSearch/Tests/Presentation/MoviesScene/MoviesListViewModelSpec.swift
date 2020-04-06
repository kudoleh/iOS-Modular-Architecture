//
//  MoviesListViewModelTests.swift
//  AppTests
//
//  Created by Oleh Kudinov on 17.08.19.
//

@testable import MoviesSearch
import Quick
import Nimble

class MoviesListViewModelSpec: QuickSpec {

    private enum SearchMoviesUseCaseError: Error {
        case someError
    }

    let moviesPages: [MoviesPage] = {
        let page1 = MoviesPage(page: 1, totalPages: 2, movies: [
            Movie.stub(id: "1", title: "title1", posterPath: "/1", overview: "overview1"),
            Movie.stub(id: "2", title: "title2", posterPath: "/2", overview: "overview2")])
        let page2 = MoviesPage(page: 2, totalPages: 2, movies: [
            Movie.stub(id: "3", title: "title3", posterPath: "/3", overview: "overview3")])
        return [page1, page2]
    }()

    class SearchMoviesUseCaseMock: SearchMoviesUseCase {
        var expectation: XCTestExpectation?
        var error: Error?
        var page = MoviesPage(page: 0, totalPages: 0, movies: [])

        func execute(requestValue: SearchMoviesUseCaseRequestValue,
                     cached: @escaping (MoviesPage) -> Void,
                     completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(page))
            }
            expectation?.fulfill()
            return nil
        }
    }

    override func spec() {

        describe("MoviesListViewModel") {
            var searchMoviesUseCaseMock: SearchMoviesUseCaseMock!
            beforeEach {
              searchMoviesUseCaseMock = SearchMoviesUseCaseMock()
            }

            context("when Search Movies Use Case returns first page") {
                it("should Contain only first Page in view model") {
                    // given
                    searchMoviesUseCaseMock.page = MoviesPage(page: 1, totalPages: 2, movies: self.moviesPages[0].movies)
                    let viewModel = DefaultMoviesListViewModel(searchMoviesUseCase: searchMoviesUseCaseMock)

                    // when
                    viewModel.didSearch(query: "query")

                    // then
                    expect(viewModel.currentPage).toEventually(be(1))
                    expect(viewModel.hasMorePages).toEventually(beTrue())
                }
            }

            context("when Search Movies Use Case returns first and second pages") {
                it("should Contain two Pages in view model") {
                    // given
                    searchMoviesUseCaseMock.page = MoviesPage(page: 1, totalPages: 2, movies: self.moviesPages[0].movies)
                    let viewModel = DefaultMoviesListViewModel(searchMoviesUseCase: searchMoviesUseCaseMock)
                    // when
                    viewModel.didSearch(query: "query")

                    searchMoviesUseCaseMock.page = MoviesPage(page: 2, totalPages: 2, movies: self.moviesPages[1].movies)
                    viewModel.didLoadNextPage()

                    // then
                    expect(viewModel.currentPage).toEventually(be(2))
                    expect(viewModel.hasMorePages).toEventually(beFalse())
                }
            }

            context("when Search Movies Use Case returns error") {
                it("should Contain error in view model") {
                    // given
                    let searchMoviesUseCaseMock = SearchMoviesUseCaseMock()
                    searchMoviesUseCaseMock.expectation = self.expectation(description: "contain errors")
                    searchMoviesUseCaseMock.error = SearchMoviesUseCaseError.someError
                    let viewModel = DefaultMoviesListViewModel(searchMoviesUseCase: searchMoviesUseCaseMock)
                    // when
                    viewModel.didSearch(query: "query")

                    // then
                    expect(viewModel.error.value).toNotEventually(beNil())
                }
            }

            context("when loads last page") {
                it("should not have more pages") {
                    // given
                    let searchMoviesUseCaseMock = SearchMoviesUseCaseMock()
                    searchMoviesUseCaseMock.page = MoviesPage(page: 1, totalPages: 2, movies: self.moviesPages[0].movies)
                    let viewModel = DefaultMoviesListViewModel(searchMoviesUseCase: searchMoviesUseCaseMock)
                    // when
                    viewModel.didSearch(query: "query")

                    searchMoviesUseCaseMock.page = MoviesPage(page: 2, totalPages: 2, movies: self.moviesPages[1].movies)

                    viewModel.didLoadNextPage()

                    // then
                    expect(viewModel.currentPage).toEventually(be(2))
                    expect(viewModel.hasMorePages).toEventually(beFalse())
                }
            }
        }
    }
}
