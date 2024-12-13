//
//  MovieListResponse+Extensions.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 13/12/24.
//

import Fakery
@testable import MovieApp

extension MovieListResponse {
    static func mock() -> Self {
        let faker: Faker = .init()
        return .init(
            search: [
                .init(
                    imdbID: faker.lorem.word(),
                    title: faker.lorem.sentence(),
                    year: faker.lorem.word(),
                    type: faker.lorem.word(),
                    poster: faker.internet.image()
                )
            ],
            totalResults: "1",
            response: "Success"
        )
    }
}
