//
//  MovieModel.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 10/12/24.
//

struct MovieModel: Identifiable {
    let id: String
    let title: String
    let year: String
    let type: String
    let poster: String

#if DEBUG
    static func mock() -> MovieModel {
        .init(
            id: "tt4154664",
            title: "Captain Marvel",
            year: "2019",
            type: "movie",
            poster: "https://m.media-amazon.com/images/M/MV5BZDI1NGU2ODAtNzBiNy00MWY5LWIyMGEtZjUxZjUwZmZiNjBlXkEyXkFqcGc@._V1_SX300.jpg"
        )
    }
#endif
}
