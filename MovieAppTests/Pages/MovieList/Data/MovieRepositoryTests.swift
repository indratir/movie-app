//
//  MovieRepositoryTests.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

import Cuckoo
import Nimble
import Quick
import Fakery
@testable import MovieApp

final class MovieRepositoryTests: QuickSpec {
    override class func spec() {
        describe("MovieRepository") {
            var movieCache: MockMovieCache!
            var movieService: MockMovieService!
            var faker: Faker!
            var sut: MovieRepositoryImpl!
            
            beforeEach {
                movieCache = .init()
                movieService = .init()
                faker = .init()
                sut = .init(movieCache: movieCache, movieService: movieService)
            }
            
            describe("fetchMovies") {
                context("success") {
                    // given
                    var response: MovieListResponse!
                    beforeEach {
                        response = .mock()
                        stub(movieCache) {
                            $0.set(response: any(), for: any()).thenDoNothing()
                        }
                        stub(movieService) {
                            $0.searchMovies(keyword: any(), page: any()).then { _ in
                                return response
                            }
                        }
                    }
                    
                    it("should return MovieListResponse") {
                        waitUntil { done in
                            Task {
                                // when
                                let result = try await sut.fetchMovies(keyword: faker.lorem.word(), page: 1)
                                
                                // then
                                expect(result).to(equal(response))
                                done()
                            }
                        }
                    }
                    
                    it("should cache MovieListResponse") {
                        waitUntil { done in
                            Task {
                                // when
                                let keyword: String = faker.lorem.word()
                                let result = try await sut.fetchMovies(keyword: keyword, page: 1)
                                
                                // then
                                verify(movieCache).set(response: equal(to: result), for: equal(to: keyword))
                                done()
                            }
                        }
                    }
                }

                context("success but result is empty") {
                    it("should return MovieListResponse with empty movies") {
                        // given
                        stub(movieService) {
                            $0.searchMovies(keyword: any(), page: any()).then { _ in
                                throw NSError(domain: faker.lorem.sentence(), code: 200)
                            }
                        }
                        
                        waitUntil { done in
                            Task {
                                // when
                                let result = try await sut.fetchMovies(keyword: faker.lorem.word(), page: 1)
                                
                                // then
                                expect(result.search).to(beEmpty())
                                done()
                            }
                        }
                    }
                }
                
                context("error but cache is available") {
                    it("should return MovieListResponse from cache") {
                        // given
                        let response: MovieListResponse = .mock()
                        stub(movieCache) {
                            $0.get(for: any()).then { _ in
                                return response
                            }
                        }
                        stub(movieService) {
                            $0.searchMovies(keyword: any(), page: any()).then { _ in
                                throw URLError(.badURL)
                            }
                        }
                        
                        waitUntil { done in
                            Task {
                                // when
                                let result = try await sut.fetchMovies(keyword: faker.lorem.word(), page: 1)
                                
                                // then
                                expect(result).to(equal(response))
                                done()
                            }
                        }
                    }
                }
                
                context("error but cache not available") {
                    it("should throw an error") {
                        // given
                        let error: URLError = .init(.badServerResponse)
                        stub(movieCache) {
                            $0.get(for: any()).thenReturn(nil)
                        }
                        stub(movieService) {
                            $0.searchMovies(keyword: any(), page: any()).then { _ in
                                throw error
                            }
                        }
                        
                        waitUntil { done in
                            Task {
                                do {
                                    // when
                                    _ = try await sut.fetchMovies(keyword: faker.lorem.word(), page: 1)
                                } catch let result as URLError {
                                    // then
                                    expect(result).to(equal(error))
                                    done()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
