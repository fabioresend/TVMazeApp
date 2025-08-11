//
//  XCTest+Extension.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import XCTest

extension XCTestCase {

    // Helper to wait for async operations in tests
    func waitForAsync(
        timeout: TimeInterval = 1.0,
        operation: @escaping () async -> Void
    ) async {
        await withTimeout(timeout) {
            await operation()
        }
    }

    private func withTimeout<T>(
        _ timeout: TimeInterval,
        operation: @escaping () async throws -> T
    ) async rethrows -> T {
        return try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                try await operation()
            }

            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                throw XCTestError(.timeoutWhileWaiting)
            }

            let result = try await group.next()!
            group.cancelAll()
            return result
        }
    }
}
