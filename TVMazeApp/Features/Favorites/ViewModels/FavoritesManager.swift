//
//  FavoritesManager.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation
import Combine
import SwiftData
import Observation

@Observable
@MainActor
class FavoritesManager {
    var favoriteShows: [FavoriteShow] = []
    var favoriteShowIds: Set<Int> = []

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadFavorites()
    }

    // MARK: - Public Methods
    func isFavorite(_ show: Show) -> Bool {
        favoriteShowIds.contains(show.id)
    }

    func toggleFavorite(_ show: Show) {
        if isFavorite(show) {
            removeFavorite(show)
        } else {
            addFavorite(show)
        }
    }

    func addFavorite(_ show: Show) {
        guard !isFavorite(show) else { return }

        let favoriteShow = FavoriteShow(from: show)
        modelContext.insert(favoriteShow)

        do {
            try modelContext.save()
            loadFavorites()
        } catch {
            print("Error adding favorite: \(error)")
        }
    }

    func removeFavorite(_ show: Show) {
        let predicate = #Predicate<FavoriteShow> { $0.showId == show.id }
        let descriptor = FetchDescriptor<FavoriteShow>(predicate: predicate)

        do {
            let results = try modelContext.fetch(descriptor)
            for favoriteShow in results {
                modelContext.delete(favoriteShow)
            }
            try modelContext.save()
            loadFavorites()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }

    func removeFavorite(_ favoriteShow: FavoriteShow) {
        modelContext.delete(favoriteShow)

        do {
            try modelContext.save()
            loadFavorites()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }

    private func loadFavorites() {
        let descriptor = FetchDescriptor<FavoriteShow>(
            sortBy: [SortDescriptor(\.dateAdded, order: .reverse)]
        )

        do {
            favoriteShows = try modelContext.fetch(descriptor).sorted(by: { $0.name < $1.name })
            favoriteShowIds = Set(favoriteShows.map { $0.showId })
        } catch {
            print("Error loading favorites: \(error)")
        }
    }
}
