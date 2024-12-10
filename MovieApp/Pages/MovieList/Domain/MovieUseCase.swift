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
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieServiceImpl()) {
        self.movieService = movieService
    }
    
    func searchMovies(keyword: String, page: Int) async throws -> [MovieModel] {
        do {
            let response = try await movieService.searchMovies(keyword: keyword, page: page)
            return response.toMovieModels()
        } catch (let error as NSError) {
            if error.code == 200 {
                return []
            }
            throw error
        }
    }
}
