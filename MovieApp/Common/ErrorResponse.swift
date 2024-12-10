//
//  ErrorResponse.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 10/12/24.
//

struct ErrorResponse: Decodable {
    let response: String?
    let error: String
    
    private enum CodingKeys: String, CodingKey {
        case response = "Response"
        case error = "Error"
    }
}
