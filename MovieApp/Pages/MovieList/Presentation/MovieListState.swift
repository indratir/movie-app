//
//  MovieListState.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

enum MovieListState: Equatable {
    case shimmer
    case items
    case empty
    case noInternet
    case error(String)
}

enum MovieListPaginationState: Equatable {
    case loading
    case end
    case error
}
