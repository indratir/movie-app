//
//  MovieServiceTests.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

import Cuckoo
import Nimble
import Quick
import Fakery
@testable import MovieApp

final class MovieServiceTests: QuickSpec {
    override class func spec() {
        describe("MovieService") {
            var apiClient: MockAPIClient!
            var faker: Faker!
            var sut: MovieServiceImpl!
            
            beforeEach {
                apiClient = .init()
                faker = .init()
                sut = .init(apiClient: apiClient)
            }
            
            describe("searchMovies") {
                it("should return MovieListResponse") {
                    waitUntil { done in
                        Task {
                            // given
                            var url: String?
                            var method: APIClientImpl.Method?
                            var parameters: [String: String?]?
                            let response: MovieListResponse = .mock()
                            
                            stub(apiClient) {
                                $0.request(url: any(), method: any(), parameters: any()).then { _url, _method, _parameters in
                                    url = _url
                                    method = _method
                                    parameters = _parameters
                                    return response
                                }
                            }
                            
                            // when
                            let keyword: String = faker.lorem.word()
                            let page: Int = 1
                            let expectedParameters: [String: String] = [
                                "s": keyword,
                                "page": "\(page)",
                                "apikey": MovieAppConstant.apiKey
                            ]
                            let result = try await sut.searchMovies(keyword: keyword, page: page)
                            
                            expect(result).to(equal(response))
                            expect(url).to(equal(MovieAppConstant.baseUrl))
                            expect(method).to(equal(.get))
                            expect(parameters).to(equal(expectedParameters))
                            done()
                        }
                    }
                }
            }
        }
    }
}
