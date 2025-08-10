//
//  ShowSearchViewModel.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import Foundation
import Combine

@MainActor
final class ShowSearchViewModel: ObservableObject {

    @Published var searchText = ""
    @Published var searchResults: [Show] = []
    @Published var isSearching = false
    @Published var error: Error?
    @Published var hasSearched = false

    private let networkService: NetworkServiceProtocol
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        setupSearchDebounce()
    }

    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                Task {
                    await self?.performSearch(query: searchText)
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    private func performSearch(query: String) async {
        // Cancel previous search
        searchTask?.cancel()

        guard !query.isEmpty else {
            searchResults = []
            hasSearched = false
            return
        }

        searchTask = Task {
            isSearching = true
            error = nil
            hasSearched = true

            do {
                let results: [SearchShowResult] = try await networkService.fetch(APIEndpoint.Shows.search(query: query))

                if !Task.isCancelled {
                    searchResults = results.map { $0.show }
                }
            } catch {
                if !Task.isCancelled {
                    self.error = error
                    searchResults = []
                }
            }

            isSearching = false
        }
    }

    func clearSearch() {
        searchText = ""
        searchResults = []
        hasSearched = false
        searchTask?.cancel()
    }
}
