//
//  MovieUseCase.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 10/12/24.
//

import Foundation

protocol MovieUseCase {
    func searchMovies(keyword: String, page: Int) async throws -> [MovieModel]
}

final class MovieUseCaseImpl: MovieUseCase {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }
    
    func searchMovies(keyword: String, page: Int) async throws -> [MovieModel] {
        try await movieRepository.fetchMovies(keyword: keyword, page: page).toMovieModels()
    }
}
