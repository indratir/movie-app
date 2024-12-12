//
//  MovieListResponse.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 10/12/24.
//

struct MovieListResponse: Codable {
    struct Item: Codable {
        let imdbID: String?
        let title: String?
        let year: String?
        let type: String?
        let poster: String?
        
        private enum CodingKeys: String, CodingKey {
            case imdbID
            case title = "Title"
            case year = "Year"
            case type = "Type"
            case poster = "Poster"
        }
    }
    
    let search: [Item]?
    let totalResults: String?
    let response: String?
    
    private enum CodingKeys: String, CodingKey {
        case totalResults
        case search = "Search"
        case response = "Response"
    }
    
    func toMovieModels() -> [MovieModel] {
        search?.map {
            .init(
                id: $0.imdbID ?? "",
                title: $0.title ?? "",
                year: $0.year ?? "",
                type: $0.type ?? "",
                poster: $0.poster ?? ""
            )
        } ?? []
    }
}
