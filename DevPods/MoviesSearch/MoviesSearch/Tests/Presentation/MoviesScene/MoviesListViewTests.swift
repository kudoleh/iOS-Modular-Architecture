//
//  MoviesListViewSnapshotTests.swift
//  Alamofire
//
//  Created by Oleh Kudinov on 05/04/2020.
//

import Foundation
import FBSnapshotTestCase
@testable import MoviesSearch

class MoviesListViewTests: FBSnapshotTestCase {
    
    let perPixelTolerance: CGFloat = 6/256

    let movies: [Movie] = [
            Movie.stub(id: "1", title: "title1", posterPath: "/1", overview: "overview1"),
            Movie.stub(id: "2", title: "title2", posterPath: "/2", overview: "overview2"),
            Movie.stub(id: "3", title: "title3", posterPath: "/3", overview: "overview3")
    ]

    override func setUp() {
        super.setUp()
        self.recordMode = false
    }

    func test_whenViewIsEmpty_thenShowEmptyScreen() {
        // given
        let vc = MoviesListViewController.create(
            with: MoviesListViewModelMock.stub(isEmpty: true,
                                               searchBarPlaceholder: NSLocalizedString("Search Movies", comment: "")
            ),
            posterImagesRepository: PosterImagesRepositoryMock())

        // then
        FBSnapshotVerifyView(vc.view, perPixelTolerance: perPixelTolerance)
    }

    func test_whenHasItems_thenShowItemsOnScreen() {
        // given
        let items = movies.map(MoviesListItemViewModel.init)
        let vc = MoviesListViewController.create(
            with: MoviesListViewModelMock.stub(items: Observable(items),
                                               isEmpty: false,
                                               searchBarPlaceholder: NSLocalizedString("Search Movies", comment: "")
            ),
            posterImagesRepository: PosterImagesRepositoryMock())

        // then
        FBSnapshotVerifyView(vc.view, perPixelTolerance: perPixelTolerance)
    }
}


struct MoviesListViewModelMock: MoviesListViewModel {
    // MARK: - Input
    func viewDidLoad() {}
    func didLoadNextPage() {}
    func didSearch(query: String) {}
    func didCancelSearch() {}
    func showQueriesSuggestions() {}
    func closeQueriesSuggestions() {}
    func didSelectItem(at index: Int) {}

    // MARK: - Output
    var items: Observable<[MoviesListItemViewModel]>
    var loading: Observable<MoviesListViewModelLoading?>
    var query: Observable<String>
    var error: Observable<String>
    var isEmpty: Bool
    var screenTitle: String
    var errorTitle: String
    var searchBarPlaceholder: String
    var emptySearchTitle: String
    var emptySearchSubtitle: String
    var noResultsTitle: String
    var noResultsSubtitleFormat: String

    func noResultsSubtitle(forQuery query: String) -> String {
        String(format: noResultsSubtitleFormat, query)
    }

    static func stub(items: Observable<[MoviesListItemViewModel]> = Observable([]),
                     loading: Observable<MoviesListViewModelLoading?> = Observable(nil),
                     query: Observable<String> = Observable(""),
                     error: Observable<String> = Observable(""),
                     isEmpty: Bool = true,
                     screenTitle: String = NSLocalizedString("Movies", comment: ""),
                     errorTitle: String = NSLocalizedString("Error", comment: ""),
                     searchBarPlaceholder: String = NSLocalizedString("Search Movies", comment: ""),
                     emptySearchTitle: String = NSLocalizedString("Search Movies", comment: ""),
                     emptySearchSubtitle: String = NSLocalizedString("Type a title above and results will appear as you type.", comment: ""),
                     noResultsTitle: String = NSLocalizedString("No Results", comment: ""),
                     noResultsSubtitleFormat: String = NSLocalizedString("No movies found for \u{201c}%@\u{201d}. Try another title.", comment: "")) -> Self {
        .init(items: items,
              loading: loading,
              query: query,
              error: error,
              isEmpty: isEmpty,
              screenTitle: screenTitle,
              errorTitle: errorTitle,
              searchBarPlaceholder: searchBarPlaceholder,
              emptySearchTitle: emptySearchTitle,
              emptySearchSubtitle: emptySearchSubtitle,
              noResultsTitle: noResultsTitle,
              noResultsSubtitleFormat: noResultsSubtitleFormat)
    }
}
