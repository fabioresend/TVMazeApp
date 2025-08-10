//
//  APIEndpoint+Episodes.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation

extension APIEndpoint {
    enum Episodes: Endpoint {
        case details(id: Int)

        func url() throws -> URL {
            var components = URLComponents(string: APIEndpoint.baseURL)!

            switch self {
            case .details(let id):
                components.path = "/episodes/\(id)"

                guard let url = components.url else {
                    throw NetworkError.invalidURL
                }
                return url
            }
        }
    }
}
