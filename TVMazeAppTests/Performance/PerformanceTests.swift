//
//  PerformanceTests.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import XCTest
@testable import TVMazeApp
import Combine

class PerformanceTests: XCTestCase {

    func testShowListPerformance() {
        let shows = (1...1000).map { id in
            Show(
                id: id,
                name: "Show \(id)",
                genres: ["Drama"],
                schedule: nil,
                image: nil,
                summary: "Summary for show \(id)",
                rating: Rating(average: Double.random(in: 1...10)),
                embedded: nil
            )
        }

        self.measure {
            let _ = shows.filter { $0.rating?.average ?? 0 > 5.0 }
        }
    }

    func testFavoriteShowConversion() {
        let show = Show(
            id: 1,
            name: "Test Show",
            genres: Array(repeating: "Genre", count: 10),
            schedule: Schedule(time: "21:00", days: ["Monday", "Tuesday", "Wednesday"]),
            image: ShowImage(medium: "https://example.com/image.jpg", original: nil),
            summary: String(repeating: "This is a very long summary. ", count: 100),
            rating: Rating(average: 8.5),
            embedded: nil
        )

        self.measure {
            let favoriteShow = FavoriteShow(from: show)
            let _ = favoriteShow.toShow()
        }
    }
}

class PerformanceTestHelper {

    static func measureTime<T>(operation: () throws -> T) rethrows -> (result: T, time: TimeInterval) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return (result, timeElapsed)
    }

    static func measureAsyncTime<T>(operation: () async throws -> T) async rethrows -> (result: T, time: TimeInterval) {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try await operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        return (result, timeElapsed)
    }
}
