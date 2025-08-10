//
//  ShowSearchView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

struct ShowSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ShowSearchViewModel()
    @State private var selectedShow: Show?
    @FocusState private var isSearchFieldFocused: Bool

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.searchText.isEmpty && !viewModel.hasSearched {
                    EmptySearchView()
                } else if viewModel.isSearching {
                    LoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.hasSearched && viewModel.searchResults.isEmpty {
                    NoResultsView(query: viewModel.searchText)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.searchResults) { show in
                                ShowCardView(show: show)
                                    .onTapGesture {
                                        selectedShow = show
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search TV shows..."
            )
            .searchFocused($isSearchFieldFocused)
            .navigationDestination(item: $selectedShow) { show in
                SeriesDetailView(show: show)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                isSearchFieldFocused = true
            }
        }
    }
}

struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("Search for TV Shows")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Find your favorite shows by typing in the search bar above")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NoResultsView: View {
    let query: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tv.slash")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No Results Found")
                .font(.title2)
                .fontWeight(.semibold)

            Text("We couldn't find any shows matching \"\(query)\"")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Text("Try searching with different keywords")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
