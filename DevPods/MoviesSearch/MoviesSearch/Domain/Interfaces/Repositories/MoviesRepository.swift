//
//  MoviesRepositoryInterfaces.swift
//  App
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

protocol MoviesRepository {
    @discardableResult
    func moviesList(query: MovieQuery, page: Int, completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable?
}
