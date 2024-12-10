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
    private var cancellables: Set<AnyCancellable> = .init()
    private var page: Int = 1
    private var isLoading: Bool = false
    @Published var isNextPageAvailable: Bool = false
    @Published var movies: [MovieModel] = []
    @Published var state: MovieListState = .empty
    @Published var keyword: String = ""
    
    init(movieUseCase: MovieUseCase = MovieUseCaseImpl()) {
        self.movieUseCase = movieUseCase
    }
    
    func setupKeyword() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        $keyword
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] keyword in
                guard let self else { return }
                self.page = 1
                self.movies.removeAll()
                self.state = .shimmer
                self.searchMovies(keyword: keyword, page: self.page)
            }
            .store(in: &cancellables)
    }
    
    func fetchNextPage() {
        guard !isLoading else { return }
        page += 1
        searchMovies(keyword: keyword, page: page)
    }
    
    private func searchMovies(keyword: String, page: Int) {
        Task {
            isLoading = true
            do {
                let movies = try await movieUseCase.searchMovies(keyword: keyword, page: page)
                self.movies += movies
                if state != .items {
                    state = movies.isEmpty ? .empty : .items
                }
                self.isNextPageAvailable = !movies.isEmpty && state == .items
            } catch {
                state = .empty
            }
            isLoading = false
        }
    }
}
