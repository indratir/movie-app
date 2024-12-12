//
//  MovieCache.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

import Foundation

protocol MovieCache {
    func set(response: MovieListResponse, for keyword: String)
    func get(for keyword: String) -> MovieListResponse?
}

final class MovieCacheImpl: MovieCache {
    private let userDefaults: UserDefaultsProtocol

    init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func set(response: MovieListResponse, for keyword: String) {
        if let data = try? JSONEncoder().encode(response) {
            userDefaults.set(data, forKey: "movie-list:\(keyword)")
        }
    }

    func get(for keyword: String) -> MovieListResponse? {
        var result: MovieListResponse?
        if let data = userDefaults.data(forKey: "movie-list:\(keyword)") {
            result = try? JSONDecoder().decode(MovieListResponse.self, from: data)
        }
        return result
    }
}
