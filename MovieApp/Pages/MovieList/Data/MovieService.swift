//
//  MovieService.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 10/12/24.
//

protocol MovieService {
    func searchMovies(keyword: String, page: Int) async throws -> MovieListResponse
}

final class MovieServiceImpl: MovieService {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClientImpl()) {
        self.apiClient = apiClient
    }
    
    func searchMovies(keyword: String, page: Int) async throws -> MovieListResponse {
        let parameters: [String: String?] = ["s": keyword, "apikey": MovieAppConstant.apiKey, "page": "\(page)"]
        return try await apiClient.request(url: MovieAppConstant.baseUrl, method: .get, parameters: parameters)
    }
}


