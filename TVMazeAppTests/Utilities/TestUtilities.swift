//
//  TestUtilities.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Combine
import SwiftData
@testable import TVMazeApp

class TestUtilities {

    // Simulate network delay for testing loading states
    static func simulateNetworkDelay() async {
        try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
    }

    // Helper to create test model context (for real usage if needed)
    static func createTestModelContext() -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: FavoriteShow.self, configurations: config)
        return ModelContext(container)
    }

    // Helper to create sample shows with different properties
    static func createTestShow(
        id: Int,
        name: String,
        genres: [String]? = nil,
        rating: Double? = nil
    ) -> Show {
        return Show(
            id: id,
            name: name,
            genres: genres,
            schedule: nil,
            image: nil,
            summary: nil,
            rating: rating != nil ? Rating(average: rating) : nil,
            embedded: nil
        )
    }

    // Helper to create mock favorites manager
    @MainActor static func createMockFavoritesManager() -> MockFavoritesManager {
        return MockFavoritesManager()
    }
}
