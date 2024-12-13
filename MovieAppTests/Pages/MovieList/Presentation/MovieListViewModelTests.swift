//
//  MovieListViewModelTests.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 13/12/24.
//

import Cuckoo
import Nimble
import Quick
import Fakery
import Combine
@testable import MovieApp

final class MovieListViewModelTests: QuickSpec {
    override class func spec() {
        describe("MovieListViewModel") {
            let defaultSearchKeyword: String = "marvel"
            var movieUseCase: MockMovieUseCase!
            var networkMonitor: MockNetworkMonitor!
            var faker: Faker!
            var sut: MovieListViewModel!
            
            beforeEach {
                movieUseCase = .init()
                networkMonitor = .init()
                faker = .init()
                sut = .init(movieUseCase: movieUseCase, networkMonitor: networkMonitor)
            }
            
            describe("onAppear") {
                context("success") {
                    var models: [MovieModel]!
                    beforeEach {
                        // given
                        models = [.mock()]
                        stub(movieUseCase) {
                            $0.searchMovies(keyword: any(), page: any()).then { _ in
                                return models
                            }
                        }
                        stub(networkMonitor) {
                            $0.isConnected().then { Just(true).eraseToAnyPublisher() }
                        }
                    }
                    
                    it("should show state items") {
                        // given
                        expect(sut.state).to(equal(.shimmer))
                        expect(sut.paginationState).to(equal(.loading))
                        
                        // when
                        sut.onAppear()
                        
                        // then
                        expect(sut.state).toEventually(equal(.items))
                        expect(sut.paginationState).to(equal(.loading))
                        expect(sut.movies).to(equal(models))
                    }
                    
                    context("when user type new keyword") {
                        it("should search with new keyword") {
                            // given
                            sut.keyword = faker.lorem.word()
                            
                            // when
                            sut.onAppear()
                            
                            // then
                            expect(sut.movies).toEventually(equal(models))
                            verify(movieUseCase).searchMovies(keyword: equal(to: sut.keyword), page: any())
                        }
                    }
                }
                
                context("success but got empty result") {
                    it("should show state empty") {
                        // given
                        stub(movieUseCase) {
                            $0.searchMovies(keyword: any(), page: any()).then { _ in
                                return []
                            }
                        }
                        stub(networkMonitor) {
                            $0.isConnected().then { Just(true).eraseToAnyPublisher() }
                        }
                        
                        expect(sut.state).to(equal(.shimmer))
                        
                        // when
                        sut.onAppear()
                        
                        
                        // then
                        expect(sut.state).toEventually(equal(.empty))
                        expect(sut.movies).to(beEmpty())
                    }
                }
                
                context("error no internet connection") {
                    it("should show state noInternet") {
                        // given
                        stub(movieUseCase) {
                            $0.searchMovies(keyword: any(), page: any()).then { _ in
                                throw URLError(.notConnectedToInternet)
                            }
                        }
                        stub(networkMonitor) {
                            $0.isConnected().then { Just(false).eraseToAnyPublisher() }
                        }
                        
                        expect(sut.state).to(equal(.shimmer))
                        
                        // when
                        sut.onAppear()
                        
                        // then
                        expect(sut.state).toEventually(equal(.noInternet))
                    }
                }
                
                context("error response") {
                    it("should show state error") {
                        // given
                        let error: URLError = .init(.cannotDecodeContentData)
                        stub(movieUseCase) {
                            $0.searchMovies(keyword: any(), page: any()).then { _ in
                                throw error
                            }
                        }
                        stub(networkMonitor) {
                            $0.isConnected().then { Just(true).eraseToAnyPublisher() }
                        }
                        
                        expect(sut.state).to(equal(.shimmer))
                        
                        // when
                        sut.onAppear()
                        
                        // then
                        expect(sut.state).toEventually(equal(.error(error.localizedDescription)))
                    }
                }
            }
            
            describe("onReload") {
                it("should re-call API with current keyword dan page") {
                    // given
                    var keyword: String?
                    let givenKeyword: String = faker.lorem.word()
                    
                    stub(movieUseCase) {
                        $0.searchMovies(keyword: any(), page: any()).then { _keyword, _ in
                            keyword = _keyword
                            return []
                        }
                    }
                    
                    // when
                    sut.keyword = givenKeyword
                    sut.onReload()
                    
                    // then
                    expect(keyword).toEventually(equal(givenKeyword))
                    verify(movieUseCase).searchMovies(keyword: equal(to: givenKeyword), page: equal(to: 1))
                }
            }
            
            describe("onScrollBottom") {
                var models: [MovieModel]!
                beforeEach {
                    // given
                    models = [.mock()]
                    stub(movieUseCase) {
                        $0.searchMovies(keyword: any(), page: equal(to: 2)).then { _ in
                            return models
                        }
                    }
                }
                
                context("when keyword is empty") {
                    it("should fetch movies in page 2 with defaultSearchKeyword") {
                        // when
                        sut.keyword = ""
                        sut.onScrollToBottom()
                        
                        // then
                        expect(sut.movies).toEventually(equal(models))
                        verify(movieUseCase).searchMovies(keyword: equal(to: defaultSearchKeyword), page: equal(to: 2))
                    }
                }
                
                context("when keyword is not empty") {
                    it("should fetch movies in page 2 with given keyword") {
                        // when
                        sut.keyword = faker.lorem.word()
                        sut.onScrollToBottom()
                        
                        // then
                        expect(sut.movies).toEventually(equal(models))
                        verify(movieUseCase).searchMovies(keyword: equal(to: sut.keyword), page: equal(to: 2))
                    }
                }
            }
        }
    }
}
