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

    /// Captures the callbacks instead of calling them, so a test decides when (and in which order) responses arrive.
    private class CapturingSearchMoviesUseCaseMock: SearchMoviesUseCase {
        private(set) var cachedCallbacks: [(MoviesPage) -> Void] = []
        private(set) var completions: [(Result<MoviesPage, Error>) -> Void] = []

        func execute(requestValue: SearchMoviesUseCaseRequestValue,
                     cached: @escaping (MoviesPage) -> Void,
                     completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable? {
            cachedCallbacks.append(cached)
            completions.append(completion)
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

    func test_whenNewerSearchStartsBeforeOlderSearchCompletes_thenStaleResponseIsIgnored() {
        // given
        let mock = CapturingSearchMoviesUseCaseMock()
        let viewModel = DefaultMoviesListViewModel(searchMoviesUseCase: mock)

        // when
        viewModel.didSearch(query: "first query")
        viewModel.didSearch(query: "second query")
        XCTAssertEqual(mock.completions.count, 2)

        // The newer (second) request's response arrives first...
        mock.completions[1](.success(MoviesPage(page: 1, totalPages: 1, movies: [.stub(id: "second")])))
        // ...then the superseded (first) request's response arrives late.
        mock.completions[0](.success(MoviesPage(page: 1, totalPages: 1, movies: [.stub(id: "first")])))

        // then: the stale "first" response must not overwrite the fresher "second" results
        XCTAssertEqual(viewModel.items.value, [MoviesListItemViewModel(movie: .stub(id: "second"))])
    }

    func test_whenNewerSearchStartsBeforeOlderSearchReturnsCachedData_thenStaleCachedDataIsIgnored() {
        // given
        let mock = CapturingSearchMoviesUseCaseMock()
        let viewModel = DefaultMoviesListViewModel(searchMoviesUseCase: mock)

        // when
        viewModel.didSearch(query: "first query")
        viewModel.didSearch(query: "second query")
        XCTAssertEqual(mock.cachedCallbacks.count, 2)

        // Stale cached data for the superseded (first) request arrives late.
        mock.cachedCallbacks[0](MoviesPage(page: 1, totalPages: 1, movies: [.stub(id: "staleCached")]))

        // then: it is ignored (the second request hasn't returned anything yet)
        XCTAssertTrue(viewModel.items.value.isEmpty)
    }

    func test_whenSearchIsCancelled_thenLateResponseForCancelledSearchIsIgnored() {
        // given
        let mock = CapturingSearchMoviesUseCaseMock()
        let viewModel = DefaultMoviesListViewModel(searchMoviesUseCase: mock)

        // when
        viewModel.didSearch(query: "query")
        viewModel.didCancelSearch()
        mock.completions[0](.success(MoviesPage(page: 1, totalPages: 1, movies: [.stub(id: "lateResult")])))

        // then: the late response for the cancelled search must not repopulate the list
        XCTAssertTrue(viewModel.items.value.isEmpty)
    }
}
