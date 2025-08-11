//
//  MazeEndpoint+Shows.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation

extension APIEndpoint {
    enum Shows: Endpoint {
        case list(page: Int)
        case search(query: String)
        case episodes(showId: Int)

        func url() throws -> URL {
            var components = URLComponents(string: APIEndpoint.baseURL)!

            switch self {
            case .list(let page):
                components.path = "/shows"
                components.queryItems = [URLQueryItem(name: "page", value: "\(page)")]

            case .search(let query):
                components.path = "/search/shows"
                components.queryItems = [URLQueryItem(name: "q", value: query)]

            case .episodes(let showId):
                components.path = "/shows/\(showId)/episodes"
            }

            guard let url = components.url else {
                throw NetworkError.invalidURL
            }
            return url
        }
    }
}

