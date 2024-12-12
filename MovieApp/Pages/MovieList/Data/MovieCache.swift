//
//  MovieCache.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

import Foundation

protocol MovieCache {
    func set<T: Encodable>(response: T, for keyword: String)
    func get<T: Decodable>(for keyword: String) -> T?
}

final class MovieCacheImpl: MovieCache {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func set<T: Encodable>(response: T, for keyword: String) {
        if let data = try? JSONEncoder().encode(response) {
            userDefaults.set(data, forKey: "movie-list:\(keyword)")
        }
    }
    
    func get<T: Decodable>(for keyword: String) -> T? {
        if let data = userDefaults.data(forKey: "movie-list:\(keyword)") {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
}
