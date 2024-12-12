//
//  MovieListView.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 10/12/24.
//

import SwiftUI

struct MovieListView: View {
    private let shimmerCount: Int = 5
    @ObservedObject private var viewModel: MovieListViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .shimmer:
                    shimmerView()
                case .items:
                    List {
                        ForEach(viewModel.movies) { movie in
                            MovieItemView(movie: movie)
                        }
                        
                        if viewModel.isNextPageAvailable {
                            MovieItemShimmerView()
                                .onAppear {
                                    viewModel.onScrollToBottom()
                                }
                        }
                    }
                case .empty:
                    emptyView()
                case .noInternet:
                    noInternetView()
                case .error(let message):
                    errorView(message: message)
                }
            }
            .navigationTitle("Movie List")
            .toolbar {
                if !viewModel.isNetworkConnected {
                    ProgressView()
                }
            }
        }
        .searchable(text: $viewModel.keyword)
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    private func shimmerView() -> some View {
        List {
            ForEach(0..<shimmerCount, id: \.self) { _ in
                MovieItemShimmerView()
            }
        }
    }
    
    private func emptyView() -> some View {
        ContentUnavailableView.search(text: viewModel.keyword)
    }
    
    private func noInternetView() -> some View {
        ContentUnavailableView {
            Label("No Internet Connection", systemImage: "wifi.slash")
        } description: {
            Text("Please check your internet connection")
        } actions: {
            Button {
                viewModel.onReload()
            } label: {
                Label("Reload", systemImage: "arrow.clockwise")
            }
        }
    }
    
    private func errorView(message: String) -> some View {
        ContentUnavailableView {
            Label("An error occurred", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button {
                viewModel.onReload()
            } label: {
                Label("Try again", systemImage: "arrow.clockwise")
            }
        }
    }
}

#Preview {
    MovieListView()
}
