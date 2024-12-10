//
//  MovieListView.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 10/12/24.
//

import SwiftUI

struct MovieListView: View {
    @State private var searchText: String = ""
    @ObservedObject private var viewModel: MovieListViewModel = .init()
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .shimmer:
                    List {
                        ForEach(0..<10, id: \.self) { _ in
                            MovieItemShimmerView()
                        }
                    }
                case .items:
                    List {
                        ForEach(viewModel.movies, id: \.imdbID) { movie in
                            MovieItemView(movie: movie)
                        }
                        
                        if viewModel.isNextPageAvailable {
                            MovieItemShimmerView()
                                .onAppear {
                                    viewModel.fetchNextPage()
                                }
                        }
                    }
                case .empty:
                    ContentUnavailableView.search(text: viewModel.keyword)
                }
                
            }
            .navigationTitle("Movie List")
        }
        .searchable(text: $viewModel.keyword)
        .onAppear {
            viewModel.setupKeyword()
        }
    }
}

struct MovieItemShimmerView: View {
    var body: some View {
        HStack(alignment: .top) {
            ShimmerView()
                .frame(width: 90, height: 120)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 16) {
                ShimmerView()
                    .frame(width: 160, height: 16)
                    .cornerRadius(8)
                
                ShimmerView()
                    .frame(width: 120, height: 12)
                    .cornerRadius(8)
            }
        }
    }
}

struct MovieItemView: View {
    @State var movie: MovieModel
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: .init(string: movie.poster)) { image in
                image.image?.resizable()
            }
                .frame(width: 90, height: 120)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                
                Text(movie.year)
                    .font(.subheadline)
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
            }
        }
    }
}

enum MovieListState: Equatable {
    case shimmer
    case items
    case empty
}

#Preview {
    MovieListView()
}
