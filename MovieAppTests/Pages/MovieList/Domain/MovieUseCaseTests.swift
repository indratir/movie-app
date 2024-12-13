//
//  MovieUseCaseTests.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 13/12/24.
//

import Cuckoo
import Nimble
import Quick
import Fakery
@testable import MovieApp

final class MovieUseCaseTests: QuickSpec {
    override class func spec() {
        describe("MovieUseCase") {
            var movieRepository: MockMovieRepository!
            var faker: Faker!
            var sut: MovieUseCaseImpl!

            beforeEach {
                movieRepository = .init()
                faker = .init()
                sut = .init(movieRepository: movieRepository)
            }

            describe("searchMovies") {
                context("success") {
                    it("should return array of MovieModel") {
                        // given
                        let response: MovieListResponse = .mock()
                        stub(movieRepository) {
                            $0.fetchMovies(keyword: any(), page: any()).then { _ in
                                return response
                            }
                        }

                        waitUntil { done in
                            Task {
                                // when
                                let result = try await sut.searchMovies(keyword: faker.lorem.word(), page: 1)

                                // then
                                expect(result).to(equal(response.toMovieModels()))
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}
