//
//  MovieCacheTests.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

import Cuckoo
import Nimble
import Quick
import Fakery
@testable import MovieApp

final class MovieCacheTests: QuickSpec {
    override class func spec() {
        describe("MovieCache") {
            var userDefaults: MockUserDefaultsProtocol!
            var faker: Faker!
            var sut: MovieCacheImpl!
            
            beforeEach {
                userDefaults = .init()
                faker = .init()
                sut = .init(userDefaults: userDefaults)
            }
            
            describe("set") {
                it("cached values should equal with the given one") {
                    // given
                    var cachedResponse: MovieListResponse?
                    var cachedKey: String?
                    
                    let givenResponse: MovieListResponse = .mock()
                    let givenKey: String = faker.lorem.word()
                    
                    stub(userDefaults) {
                        $0.set(any(), forKey: any()).then { value, key in
                            if let data = value as? Data, let response = try? JSONDecoder().decode(MovieListResponse.self, from: data) {
                                cachedResponse = response
                            }
                            
                            cachedKey = key
                        }
                    }
                    
                    // when
                    sut.set(response: givenResponse, for: givenKey)
                    
                    // then
                    expect(cachedKey).to(equal("movie-list:\(givenKey)"))
                    expect(cachedResponse).to(equal(givenResponse))
                }
            }
            
            describe("get") {
                it("returned value should equal with the given one") {
                    // given
                    let givenResponse: MovieListResponse = .mock()
                    stub(userDefaults) {
                        $0.data(forKey: any()).then { _ in
                            var data: Data?
                            if let value = try? JSONEncoder().encode(givenResponse) {
                                data = value
                            }
                            return data
                        }
                    }
                    
                    // when
                    let response: MovieListResponse? = sut.get(for: faker.lorem.word())
                    
                    // then
                    expect(response).to(equal(givenResponse))
                }
            }
        }
    }
}
