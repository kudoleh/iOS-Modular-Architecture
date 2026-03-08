import XCTest
@testable import MoviesSearch

final class MoviesListViewModelTests: XCTestCase {
    
    // Helper to provide stubbed data
    private let moviesPages: [MoviesPage] = {
        let page1 = MoviesPage(page: 1, totalPages: 2, movies: [
            Movie.stub(id: "1", title: "title1", posterPath: "/1", overview: "overview1"),
            Movie.stub(id: "2", title: "title2", posterPath: "/2", overview: "overview2")])
        let page2 = MoviesPage(page: 2, totalPages: 2, movies: [
            Movie.stub(id: "3", title: "title3", posterPath: "/3", overview: "overview3")])
        return [page1, page2]
    }()

    private class SearchMoviesUseCaseMock: SearchMoviesUseCase {
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
            return nil
        }
    }

    // MARK: - Tests

    func test_whenSearchReturnsFirstPage_thenViewModelContainsOnlyFirstPage() {
        // given
        let mock = SearchMoviesUseCaseMock()
        mock.page = MoviesPage(page: 1, totalPages: 2, movies: moviesPages[0].movies)
        let viewModel = DefaultMoviesListViewModel(searchMoviesUseCase: mock)

        // when
        viewModel.didSearch(query: "query")

        // then
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.hasMorePages)
    }

    func test_whenSearchReturnsTwoPages_thenViewModelContainsTwoPages() {
        // given
        let mock = SearchMoviesUseCaseMock()
        let viewModel = DefaultMoviesListViewModel(searchMoviesUseCase: mock)
        
        // when
        mock.page = MoviesPage(page: 1, totalPages: 2, movies: moviesPages[0].movies)
        viewModel.didSearch(query: "query")

        mock.page = MoviesPage(page: 2, totalPages: 2, movies: moviesPages[1].movies)
        viewModel.didLoadNextPage()

        // then
        XCTAssertEqual(viewModel.currentPage, 2)
        XCTAssertFalse(viewModel.hasMorePages)
    }

    func test_whenSearchFails_thenViewModelExposesError() {
        // given
        let mock = SearchMoviesUseCaseMock()
        mock.error = NSError(domain: "test", code: 0)
        let viewModel = DefaultMoviesListViewModel(searchMoviesUseCase: mock)

        // when
        viewModel.didSearch(query: "query")

        // then
        XCTAssertNotNil(viewModel.error.value)
    }
}
