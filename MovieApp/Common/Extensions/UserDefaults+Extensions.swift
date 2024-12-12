//
//  UserDefaults+Extensions.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

import Foundation

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func data(forKey defaultName: String) -> Data?
}

extension UserDefaults: UserDefaultsProtocol { }
