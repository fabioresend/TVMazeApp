//
//  APIEndpoint.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation

protocol Endpoint {
    func url() throws -> URL
}

// MARK: - APIEndpoint.swift
enum APIEndpoint {
    static let baseURL = "https://api.tvmaze.com"
}
