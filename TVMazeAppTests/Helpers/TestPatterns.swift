//
//  TestPatterns.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import XCTest
@testable import TVMazeApp

class TestPatterns {

    // Pattern: Test success scenario
    static func testSuccessPattern<T: Codable>(
        mockService: MockNetworkService,
        data: T,
        operation: () async -> Void,
        assertions: () -> Void
    ) async {
        // Given
        mockService.setupSuccessResponse(with: data)

        // When
        await operation()

        // Then
        assertions()
    }

    // Pattern: Test error scenario
    static func testErrorPattern(
        mockService: MockNetworkService,
        error: Error,
        operation: () async -> Void,
        assertions: () -> Void
    ) async {
        // Given
        mockService.setupErrorResponse(with: error)

        // When
        await operation()

        // Then
        assertions()
    }
}
