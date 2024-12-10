//
//  APIClient.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 10/12/24.
//

import Foundation

protocol APIClient {
    func request<T: Decodable>(url: String, method: APIClientImpl.Method, parameters: [String: String?]) async throws -> T
}

final class APIClientImpl: APIClient {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func request<T: Decodable>(url: String, method: Method, parameters: [String: String?]) async throws -> T {
        guard var urlComponents = URLComponents(string: url) else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await urlSession.data(from: url)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        guard 200 ..< 300 ~= statusCode else {
            throw URLError(.badServerResponse)
        }
        
        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            throw NSError(domain: errorResponse.error, code: statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
