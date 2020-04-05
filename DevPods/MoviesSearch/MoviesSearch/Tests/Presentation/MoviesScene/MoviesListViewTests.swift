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

    let moviesPages: [MoviesPage] = {
        let page1 = MoviesPage(page: 1, totalPages: 2, movies: [
            Movie.stub(id: "1", title: "title1", posterPath: "/1", overview: "overview1"),
            Movie.stub(id: "2", title: "title2", posterPath: "/2", overview: "overview2")])
        let page2 = MoviesPage(page: 2, totalPages: 2, movies: [
            Movie.stub(id: "3", title: "title3", posterPath: "/3", overview: "overview3")])
        return [page1, page2]
    }()

    var window: UIWindow!
    var nvc: UINavigationController!

    override func setUp() {
        super.setUp()
        //self.recordMode = true
    }

    func test_whenViewIsEmpty_thenShowEmptyScreen() {
        // given
        let vc = MoviesListViewController.create(with: MoviesListViewModelMock.stub(isEmpty: true,
                                                                                    emptyDataTitle: NSLocalizedString("Search results", comment: ""),
                                                                                    searchBarPlaceholder: NSLocalizedString("Search Movies", comment: "")),
                                                 posterImagesRepository: PosterImagesRepositoryMock())

        // then
        FBSnapshotVerifyView(vc.view)
    }

    func test_whenHasItems_thenShowItemsOnScreen() {
        // given
        let pages = moviesPages.map(MoviesListPageViewModel.init)
        let vc = MoviesListViewController.create(with: MoviesListViewModelMock.stub(pageViewModels: Observable(pages),
                                                                                    isEmpty: false,
                                                                                    emptyDataTitle: NSLocalizedString("Search results", comment: ""),
                                                                                    searchBarPlaceholder: NSLocalizedString("Search Movies", comment: "")),
                                                 posterImagesRepository: PosterImagesRepositoryMock())

        // then
        FBSnapshotVerifyView(vc.view)
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
    func didSelect(at indexPath: IndexPath) {}

    // MARK: - Output
    var pageViewModels: Observable<[MoviesListPageViewModel]>
    var loadingType: Observable<MoviesListViewModelLoading?>
    var query: Observable<String>
    var error: Observable<String>
    var isEmpty: Bool
    var screenTitle: String
    var emptyDataTitle: String
    var errorTitle: String
    var searchBarPlaceholder: String

    static func stub(pageViewModels: Observable<[MoviesListPageViewModel]> = Observable([]),
                     loadingType: Observable<MoviesListViewModelLoading?> = Observable(nil),
                     query: Observable<String> = Observable(""),
                     error: Observable<String> = Observable(""),
                     isEmpty: Bool = true,
                     screenTitle: String = NSLocalizedString("Movies", comment: ""),
                     emptyDataTitle: String = NSLocalizedString("Search results", comment: ""),
                     errorTitle: String = NSLocalizedString("Error", comment: ""),
                     searchBarPlaceholder: String = NSLocalizedString("Search Movies", comment: "")) -> Self {
        .init(pageViewModels: pageViewModels,
              loadingType: loadingType,
              query: query,
              error: error,
              isEmpty: isEmpty,
              screenTitle: screenTitle,
              emptyDataTitle: emptyDataTitle,
              errorTitle: errorTitle,
              searchBarPlaceholder: searchBarPlaceholder)
    }
}
