//
//  MockNetworkService.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import XCTest
@testable import TVMazeApp

class MockNetworkService: NetworkServiceProtocol {
    var shouldSucceed = true
    var mockData: Any?
    var mockError: Error?

    func setMockData<T>(_ data: T) {
        mockData = data
        shouldSucceed = true
        mockError = nil
    }

    func setMockError(_ error: Error) {
        mockError = error
        shouldSucceed = false
        mockData = nil
    }

    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if let error = mockError { throw error }

        if shouldSucceed {
            if let data = mockData as? T {
                return data
            } else {
                return mockData as! T
            }
        }
        throw NetworkError.noData
    }
}

extension MockNetworkService {

    // Convenience methods for common scenarios
    func setupSuccessResponse<T: Codable>(with data: T) {
        shouldSucceed = true
        mockData = data
        mockError = nil
    }

    func setupErrorResponse(with error: Error) {
        shouldSucceed = false
        mockData = nil
        mockError = error
    }

    func setupEmptyResponse<T>(_ type: T.Type) {
        shouldSucceed = true
        if type is [Any].Type {
            mockData = [] as? T
        } else {
            mockData = nil
        }
        mockError = nil
    }
}
