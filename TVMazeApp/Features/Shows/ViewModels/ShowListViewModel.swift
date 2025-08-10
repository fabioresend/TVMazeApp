//
//  ShowListViewModel.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation
import Combine

@MainActor
final class ShowListViewModel: ObservableObject {

    @Published var shows: [Show] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var error: Error?
    @Published var hasMorePages = true

    private let networkService: NetworkServiceProtocol
    private var currentPage = 0
    private var cancellables = Set<AnyCancellable>()

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        Task {
            await loadShows()
        }
    }

    func loadShows() async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            let fetchedShows: [Show] = try await networkService.fetch(APIEndpoint.Shows.list(page: currentPage))

            if fetchedShows.isEmpty {
                hasMorePages = false
            } else {
                shows.append(contentsOf: fetchedShows)
                currentPage += 1
            }
        } catch {
            self.error = error
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentShow: Show) async {
        guard let lastShow = shows.last,
              lastShow.id == currentShow.id,
              !isLoadingMore,
              hasMorePages else { return }

        isLoadingMore = true

        do {
            let fetchedShows: [Show] = try await networkService.fetch(APIEndpoint.Shows.list(page: currentPage))

            if fetchedShows.isEmpty {
                hasMorePages = false
            } else {
                shows.append(contentsOf: fetchedShows)
                currentPage += 1
            }
        } catch {
            self.error = error
        }

        isLoadingMore = false
    }

    func refresh() async {
        currentPage = 0
        hasMorePages = true
        shows = []
        await loadShows()
    }
}
