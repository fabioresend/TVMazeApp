//
//  ShowDetailViewModel.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation
import Combine

@MainActor
final class ShowDetailViewModel: ObservableObject {

    @Published var show: Show
    @Published var episodes: [Episode] = []
    @Published var groupedEpisodes: [Int: [Episode]] = [:]
    @Published var isLoading = false
    @Published var error: Error?

    private let networkService: NetworkServiceProtocol
    let favoritesManager: FavoritesManager

    init(show: Show,
         networkService: NetworkServiceProtocol = NetworkService(),
         favoritesManager: FavoritesManager) {
        self.show = show
        self.networkService = networkService
        self.favoritesManager = favoritesManager
        Task {
            await loadEpisodes()
        }
    }

    func loadEpisodes() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            // Try to get episodes from embedded data first
            if let embeddedEpisodes = show.embedded?.episodes {
                self.episodes = embeddedEpisodes
            } else {
                // Fetch episodes separately
                let fetchedEpisodes: [Episode] = try await networkService.fetch(APIEndpoint.Shows.episodes(showId: show.id))
                self.episodes = fetchedEpisodes
            }

            groupEpisodesBySeason()
        } catch {
            self.error = error
        }

        isLoading = false
    }

    private func groupEpisodesBySeason() {
        groupedEpisodes = Dictionary(grouping: episodes) { $0.season }
    }

    func forceReload() async {
        episodes = []
        groupedEpisodes = [:]
        await loadEpisodes()
    }
}
