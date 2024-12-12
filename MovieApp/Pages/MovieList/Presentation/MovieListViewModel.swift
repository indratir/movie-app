//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 10/12/24.
//

import Foundation
import Combine

final class MovieListViewModel: ObservableObject {
    private let movieUseCase: MovieUseCase
    private let networkMonitor: NetworkMonitor
    
    private var cancellables: Set<AnyCancellable> = .init()
    private var page: Int = 1
    private var isLoading: Bool = false
    private let defaultSearchKeyword: String = "marvel"
    
    @Published var isNextPageAvailable: Bool = false
    @Published var movies: [MovieModel] = []
    @Published var state: MovieListState = .shimmer
    @Published var keyword: String = ""
    @Published var isNetworkConnected: Bool = true
    
    init(
        movieUseCase: MovieUseCase = MovieUseCaseImpl(),
        networkMonitor: NetworkMonitor = NetworkMonitorImpl()
    ) {
        self.movieUseCase = movieUseCase
        self.networkMonitor = networkMonitor
    }
    
    func onAppear() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        setupKeyword()
        setupNetworkMonitor()
    }
    
    func onReload() {
        searchMovies(keyword: keyword, page: page)
    }
    
    func onScrollToBottom() {
        guard !isLoading else { return }
        page += 1
        searchMovies(keyword: keyword.isEmpty ? defaultSearchKeyword : keyword, page: page)
    }
    
    private func setupKeyword() {
        $keyword
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self, defaultSearchKeyword] keyword in
                guard let self else { return }
                self.resetState()
                self.searchMovies(keyword: keyword.isEmpty ? defaultSearchKeyword : keyword, page: self.page)
            }
            .store(in: &cancellables)
    }
    
    private func setupNetworkMonitor() {
        networkMonitor.isConnected()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                self?.isNetworkConnected = isConnected
            }
            .store(in: &cancellables)
    }
    
    private func resetState() {
        page = 1
        movies.removeAll()
        state = .shimmer
    }
    
    private func searchMovies(keyword: String, page: Int) {
        Task {
            isLoading = true
            do {
                let movies = try await movieUseCase.searchMovies(keyword: keyword, page: page)
                if page == 1 {
                    state = movies.isEmpty ? .empty : .items
                }
                self.movies += movies
                self.isNextPageAvailable = !movies.isEmpty && state == .items
            } catch {
                if page == 1 {
                    if !isNetworkConnected {
                        state = .noInternet
                    } else {
                        state = .error(error.localizedDescription)
                    }
                }
                self.isNextPageAvailable = false
            }
            isLoading = false
        }
    }
}
