//
//  MockFavoritesManager.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import XCTest
@testable import TVMazeApp
import SwiftData

class MockFavoritesManager: FavoritesManager {

    init() {
        // Create a real in-memory ModelContext for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: FavoriteShow.self, configurations: config)
        let modelContext = ModelContext(container)
        super.init(modelContext: modelContext)
    }

    override func isFavorite(_ show: Show) -> Bool {
        return favoriteShowIds.contains(show.id)
    }

    override func addFavorite(_ show: Show) {
        guard !isFavorite(show) else { return }
        favoriteShowIds.insert(show.id)
        let favoriteShow = FavoriteShow(from: show)
        favoriteShows.append(favoriteShow)
    }

    override func removeFavorite(_ show: Show) {
        favoriteShowIds.remove(show.id)
        favoriteShows.removeAll { $0.showId == show.id }
    }

    override func toggleFavorite(_ show: Show) {
        if isFavorite(show) {
            removeFavorite(show)
        } else {
            addFavorite(show)
        }
    }
}
