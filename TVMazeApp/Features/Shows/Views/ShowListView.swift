//
//  ShowListView.swift
//  TVMazeApp
//
//  Created by Fabio Augusto Resende on 8/10/25.
//

import SwiftUI

struct ShowListView: View {
    @StateObject private var viewModel = SeriesListViewModel()
    @State private var selectedShow: Show?

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading && viewModel.shows.isEmpty {
                    LoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                } else if let error = viewModel.error, viewModel.shows.isEmpty {
                    ErrorView(error: error) {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                    .padding()
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.shows) { show in
                            SeriesCardView(show: show)
                                .onTapGesture {
                                    selectedShow = show
                                }
                                .onAppear {
                                    Task {
                                        await viewModel.loadMoreIfNeeded(currentShow: show)
                                    }
                                }
                        }

                        if viewModel.isLoadingMore {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .gridCellColumns(columns.count)
                                .gridCellAnchor(.center)
                                .padding()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("TV Shows")
            .navigationDestination(item: $selectedShow) { show in
                SeriesDetailView(show: show)
            }
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                if viewModel.shows.isEmpty {
                    await viewModel.loadShows()
                }
            }
        }
    }
}


struct SeriesCardView: View {
    let show: Show

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImageView(
                url: show.image?.medium,
                placeholder: "tv"
            )
            .aspectRatio(0.68, contentMode: .fit)
            .cornerRadius(12)

            Text(show.name)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            if let rating = show.rating?.average {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)

                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
