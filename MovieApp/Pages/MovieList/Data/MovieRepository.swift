//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

import Foundation

protocol MovieRepository {
    func fetchMovies(keyword: String, page: Int) async throws -> MovieListResponse
}

final class MovieRepositoryImpl: MovieRepository {
    private let movieCache: MovieCache
    private let movieService: MovieService

    init(
        movieCache: MovieCache = MovieCacheImpl(),
        movieService: MovieService = MovieServiceImpl()
    ) {
        self.movieCache = movieCache
        self.movieService = movieService
    }

    func fetchMovies(keyword: String, page: Int) async throws -> MovieListResponse {
        do {
            let movies = try await movieService.searchMovies(keyword: keyword, page: page)
            if page == 1 {
                movieCache.set(response: movies, for: keyword)
            }
            return movies
        } catch let error as NSError {
            if let movies: MovieListResponse = movieCache.get(for: keyword) {
                return movies
            }
            if error.code == 200 {
                return .init(search: [], totalResults: nil, response: nil)
            }
            throw error
        }
    }
}
